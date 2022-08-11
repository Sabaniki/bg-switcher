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

	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	controllerutil "sigs.k8s.io/controller-runtime/pkg/controller/controllerutil"
	"sigs.k8s.io/controller-runtime/pkg/log"

	seccampv1 "github.com/Sabaniki/bg-switcher/api/v1"
	"github.com/Sabaniki/bg-switcher/pkg/util"
)

// BgSwitcherReconciler reconciles a BgSwitcher object
type BgSwitcherReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchergroups,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchergroups/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=seccamp.sabaniki.vsix.wide.ad.jp,resources=bgswitchergroups/finalizers,verbs=update

func (r *BgSwitcherReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	log := log.FromContext(ctx)
	res := util.NewResult()
	bgg := seccampv1.BgSwitcherGroup{}

	if err := r.Get(ctx, req.NamespacedName, &bgg); err != nil {
		if errors.IsNotFound(err) {
			return ctrl.Result{Requeue: true}, nil
		}
		log.Error(err, "msg", "line", util.LINE())
		return ctrl.Result{Requeue: true}, err
	}

	allOk := true
	for _, group := range bgg.Spec.Groups {
		for _, bbrouterSpecName := range group.BbRouters {
			foundBbRouterInStatus := false
			for _, bbrouterStatus := range bgg.Status.BbRouters {
				if bbrouterStatus.Name == string(bbrouterSpecName) {
					foundBbRouterInStatus = true
				}
			}
			if !foundBbRouterInStatus {
				newBbRouterStatus := seccampv1.BbRouterStatus{
					Name:    string(bbrouterSpecName),
					Color:   group.Color,
					Created: false,
					Weight:  group.Weight,
				}
				if err := r.ReconcileBgSwitcherLet(ctx, bgg, newBbRouterStatus, group.Weight); err != nil {
					log.Error(err, "msg", "line", util.LINE())
					return ctrl.Result{Requeue: true}, err
				}
				newBbRouterStatus.Created = true
				bgg.Status.BbRouters = append(
					bgg.Status.BbRouters,
					newBbRouterStatus,
				)
				allOk = false
				res.StatusUpdated = true
			}
		}
	}
	if !allOk {
		if res.SpecUpdated {
			if err := r.Update(ctx, &bgg); err != nil {
				log.Error(err, "msg", "line", util.LINE())
				return ctrl.Result{Requeue: true}, err
			}
		}
		if res.StatusUpdated {
			if err := r.Status().Update(ctx, &bgg); err != nil {
				log.Error(err, "msg", "line", util.LINE())
				return ctrl.Result{Requeue: true}, err
			}
		}
		return ctrl.Result{Requeue: true}, nil
	}

	for _, group := range bgg.Spec.Groups {
		for _, statusRouter := range bgg.Status.BbRouters {
			if group.Color == statusRouter.Color {
				if err := r.ReconcileBgSwitcherLet(ctx, bgg, statusRouter, group.Weight); err != nil {
					log.Error(err, "msg", "line", util.LINE())
					return ctrl.Result{Requeue: true}, err
				}
			}
		}
	}

	if res.SpecUpdated {
		if err := r.Update(ctx, &bgg); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{Requeue: true}, err
		}
	}
	if res.StatusUpdated {
		if err := r.Status().Update(ctx, &bgg); err != nil {
			log.Error(err, "msg", "line", util.LINE())
			return ctrl.Result{Requeue: true}, err
		}
	}
	return ctrl.Result{}, nil
}

func (r *BgSwitcherReconciler) ReconcileBgSwitcherLet(ctx context.Context, bgg seccampv1.BgSwitcherGroup, info seccampv1.BbRouterStatus, weight int) error {
	log := log.FromContext(ctx)
	bgs := seccampv1.BgSwitcher{}
	bgs.SetNamespace(bgg.GetNamespace())
	bgs.SetName(info.Name)

	op, err := ctrl.CreateOrUpdate(ctx, r.Client, &bgs, func() error {
		bgs.Spec.Color = info.Color
		bgs.Spec.Weight = weight
		return ctrl.SetControllerReference(&bgg, &bgs, r.Scheme)
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

func (r *BgSwitcherReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&seccampv1.BgSwitcherGroup{}).
		Owns(&seccampv1.BgSwitcher{}).
		Complete(r)
}
