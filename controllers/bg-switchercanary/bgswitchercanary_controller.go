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
	"time"

	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"
	"sigs.k8s.io/controller-runtime/pkg/log"

	seccampv1 "github.com/Sabaniki/bg-switcher/api/v1"
	"github.com/Sabaniki/bg-switcher/pkg/util"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// BgSwitcherCanaryReconciler reconciles a BgSwitcherCanary object
type BgSwitcherCanaryReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchercanaries,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchercanaries/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchercanaries/finalizers,verbs=update

func (r *BgSwitcherCanaryReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log := log.FromContext(ctx)
	res := util.NewResult()
	bgc := seccampv1.BgSwitcherCanary{}

	if err := r.Get(ctx, req.NamespacedName, &bgc); err != nil {
		if errors.IsNotFound(err) {
			return ctrl.Result{}, nil
		}
		log.Error(err, "msg", "line", util.LINE())
		return ctrl.Result{}, err
	}
	if err := r.Get(ctx, req.NamespacedName, &bgc); err != nil {
		if errors.IsNotFound(err) {
			return ctrl.Result{}, nil
		}
		log.Error(err, "msg", "line", util.LINE())
		return ctrl.Result{}, err
	}

	// 少なくとも時間要件を満たしていたらリコンサイルする
	acceptReconcile := bgc.Status.NextTimestamp.After(metav1.Now().Time)
	if bgc.Status.MainColor != bgc.Spec.MainColor {
		bgc.Status.MainColor = bgc.Spec.MainColor
		res.SpecUpdated = true
		acceptReconcile = true
	}

	if !acceptReconcile {
		bgc.Status.LastTimestamp = metav1.Now()
		if err := r.Status().Update(ctx, &bgc); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		}
	}

	allOk := true
	for _, specGroup := range bgc.Spec.Groups {
		foundColorInStatus := false
		for _, statusGroup := range bgc.Status.Groups {
			if specGroup.Color == statusGroup.Color {
				foundColorInStatus = true
			}
		}
		if !foundColorInStatus {
			weight := 1
			if bgc.Spec.MainColor == specGroup.Color {
				weight = 99
			}
			newGroup := seccampv1.Group{
				Color:     specGroup.Color,
				Weight:    weight,
				BbRouters: specGroup.BbRouterNames,
			}
			bgc.Status.Groups = append(bgc.Status.Groups, newGroup)
			allOk = false
			res.StatusUpdated = true
		}
	}

	if !allOk {
		if res.SpecUpdated {
			if err := r.Update(ctx, &bgc); err != nil {
				log.Error(err, "msg", "line", util.LINE())
				return ctrl.Result{}, err
			}
		}
		if res.StatusUpdated {
			if err := r.Status().Update(ctx, &bgc); err != nil {
				log.Error(err, "msg", "line", util.LINE())
				return ctrl.Result{}, err
			}
		}
		return ctrl.Result{Requeue: true}, nil
	}

	now := metav1.Now()
	bgc.Status.LastTimestamp = now
	bgc.Status.NextTimestamp = metav1.NewTime(now.Add(5 * time.Second))
	if res.SpecUpdated {
		if err := r.Update(ctx, &bgc); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		}
	}
	if res.StatusUpdated {
		if err := r.Status().Update(ctx, &bgc); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{}, err
		}
	}
	return ctrl.Result{RequeueAfter: time.Second * 1}, nil
}

func (r *BgSwitcherCanaryReconciler) ReconcileBgSwitcherGroup(ctx context.Context, bgc seccampv1.BgSwitcherCanary) error {
	log := log.FromContext(ctx)
	bgg := seccampv1.BgSwitcherGroup{}
	bgg.SetNamespace(bgc.GetNamespace())
	bgg.SetName(bgc.Name + "-group")

	op, err := ctrl.CreateOrUpdate(ctx, r.Client, &bgg, func() error {
		bgg.Spec.Groups = bgc.Status.Groups
		return ctrl.SetControllerReference(&bgg, &bgg, r.Scheme)
	})

	if err != nil {
		log.Error(err, "unable to create or update BgSwitcher resource")
		return err
	}
	if op != controllerutil.OperationResultNone {
		log.Info("reconcile BgSwitcherLet successfully", "op", op)
	}

	return nil
}

func (r *BgSwitcherCanaryReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&seccampv1.BgSwitcherCanary{}).
		Owns(&seccampv1.BgSwitcherGroup{}).
		Complete(r)
}
