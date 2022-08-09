/*
Copyright 2022.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controllers

import (
	"context"
	"os"
	"regexp"
	"strconv"
	"strings"

	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"
	"sigs.k8s.io/controller-runtime/pkg/log"

	seccampv1 "github.com/Sabaniki/bg-switcher/api/v1"
	"github.com/Sabaniki/bg-switcher/pkg/executer"
	"github.com/Sabaniki/bg-switcher/pkg/util"
	"github.com/k0kubun/pp"
)

// BgSwitcherReconciler reconciles a BgSwitcher object
type BgSwitcherLetReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchers,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchers/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchers/finalizers,verbs=update

func (r *BgSwitcherLetReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log := log.FromContext(ctx)
	res := util.NewResult()
	bgs := seccampv1.BgSwitcher{}
	name := os.Getenv("NAME")
	if err := r.Get(ctx, req.NamespacedName, &bgs); err != nil {
		if errors.IsNotFound(err) {
			return ctrl.Result{}, nil
		}
		log.Error(err, "msg", "line", util.LINE())
		return ctrl.Result{}, err
	}
	// Ignore reconcile request unrelated to me
	if bgs.GetName() != name {
		return ctrl.Result{}, nil
	}
	pp.Println("it is me.")
	containerName := convContainerName(bgs.GetName())

	// Finalizer
	finalizerName := "bg-switcherlet-" + bgs.Name
	if bgs.ObjectMeta.DeletionTimestamp.IsZero() {
		if !controllerutil.ContainsFinalizer(&bgs, finalizerName) {
			controllerutil.AddFinalizer(&bgs, finalizerName)
			res.SpecUpdated = true
		}
	} else {
		if controllerutil.ContainsFinalizer(&bgs, finalizerName) {
			controllerutil.RemoveFinalizer(&bgs, finalizerName)
			if err := r.Update(ctx, &bgs); err != nil {
				log.Error(err, "msg", "line", util.LINE())
				return ctrl.Result{}, err
			}
		}
		return ctrl.Result{}, nil
	}
	for i, group := range bgs.Spec.Groups {
		if res, err := isExistRouteMap(containerName, group.Color); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		} else if !res {
			if err = setWeight(containerName, group.Color, group.Weight, (i+1)*5); err != nil {
				log.Error(err, "msg", "line", util.LINE())
				return ctrl.Result{}, err
			}
		}
	}

	currentWeight := []int{}
	for _, group := range bgs.Spec.Groups {
		weight, err := getWeight(containerName, group.Color)
		if err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		}
		currentWeight = append(currentWeight, weight)
	}

	updateWeight := false
	newWGroup := []seccampv1.ColorGroup{}
	for i, groupSpec := range bgs.Spec.Groups {
		if groupSpec.Weight != currentWeight[i] {
			setWeight(containerName, groupSpec.Color, groupSpec.Weight, (i+1)*5)
			newWeight, err := getWeight(containerName, groupSpec.Color)
			if err != nil {
				log.Error(err, "msg", "line", util.LINE())
				return ctrl.Result{}, err
			}
			newWGroup = append(newWGroup, seccampv1.ColorGroup{
				Color:  groupSpec.Color,
				Weight: newWeight,
			})
			updateWeight = true
		}
	}
	if updateWeight {
		bgs.Status.Groups = newWGroup
		res.StatusUpdated = true
	}

	if res.SpecUpdated {
		if err := r.Update(ctx, &bgs); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		}
	}
	if res.StatusUpdated {
		if err := r.Status().Update(ctx, &bgs); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		}
	}

	return ctrl.Result{}, nil
}

func (r *BgSwitcherLetReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&seccampv1.BgSwitcher{}).
		Complete(r)
}

func isExistRouteMap(containerName string, color string) (bool, error) {
	//docker exec PE-A vtysh -c 'show route-map json' | jq ".BGP" | jq "select(type != \"null\")" | jq "[.]" | jq 'map(has("test"))[0]'
	color = strings.ToUpper(color)
	res, err := executer.ExecShowCommand(
		containerName,
		"route-map",
		".BGP",
		"select(type != \"null\")",
		"[.]",
		"map(has(\"WEIGHT_LEVEL_"+color+"\"))",
	)
	return strings.Contains(res, "true"), err
}

func getWeight(containerName string, color string) (int, error) {
	// docker exec PE-A vtysh -c 'show route-map json' | jq ".BGP" | jq "select(type != \"null\")" | jq ".WEIGHT_LEVEL_{COLOR}.rules[0].setClauses[]"
	color = strings.ToUpper(color)
	res, err := executer.ExecShowCommand(
		containerName,
		"route-map",
		".BGP",
		"select(type != \"null\")",
		".WEIGHT_LEVEL_"+color+".rules[0].setClauses[]",
	)
	if err != nil {
		return -1, err
	}
	rex := regexp.MustCompile("[0-9]+")
	num, err := strconv.ParseInt(rex.FindString(res), 10, 32)
	if err != nil {
		return -1, err
	}
	return int(num), nil
}

func setWeight(containerName string, color string, weight int, seq int) error {
	color = strings.ToUpper(color)
	err := executer.ExecCommand(
		containerName,
		"route-map WEIGHT_LEVEL_"+color+" permit "+strconv.Itoa(seq),
		"set extcommunity bandwidth "+strconv.Itoa(weight),
	)
	return err
}

// func setPeer(containerName string, color string) {
// 	config := ""
// 	strings.Contains(res, "true"), err
// }

func convContainerName(rawName string) string {
	return strings.ToUpper(rawName)
	// runes := []rune(rawName)
	// runes[0] = []rune(strings.ToUpper(string(runes[0])))[0]
	// runes[len(runes)-1] = []rune(strings.ToUpper(string(runes[len(runes)-1])))[0]
	// return string(runes)

}
