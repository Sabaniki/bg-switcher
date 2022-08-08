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
	// pp.Println("NAME", name)
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
	med, err := getMed(containerName)
	if err != nil {
		log.Error(err, "msg", "line", util.LINE())
		return ctrl.Result{}, err
	}

	changedMed := false
	if bgs.Spec.IsMain && med != 0 {
		setMed(containerName, 0)
		changedMed = true
	} else if !bgs.Spec.IsMain && med == 0 {
		setMed(containerName, 10)
		changedMed = true
	}
	if changedMed {
		currentMed, err := getMed(containerName)
		if err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		}
		bgs.Status.Med = currentMed
		res.StatusUpdated = true
	}

	if bgs.Spec.Color != bgs.Status.Color {
		bgs.Status.Color = bgs.Spec.Color
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

func getMed(containerName string) (int, error) {
	// docker exec Blue-A vtysh -c 'show route-map json' | jq ".BGP" | jq "select(type != \"null\")" | jq ".MED_LEVEL.rules[0].setClauses[]"
	res, err := executer.ExecShowCommand(
		containerName,
		"route-map",
		".BGP",
		"select(type != \"null\")",
		".MED_LEVEL.rules[0].setClauses[]",
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

func setMed(containerName string, med int) error {
	err := executer.ExecCommand(
		containerName,
		"route-map MED_LEVEL permit 5",
		"set metric "+strconv.Itoa(med),
	)
	return err
}

func convContainerName(rawName string) string {
	runes := []rune(rawName)
	runes[0] = []rune(strings.ToUpper(string(runes[0])))[0]
	runes[len(runes)-1] = []rune(strings.ToUpper(string(runes[len(runes)-1])))[0]
	return string(runes)

}
