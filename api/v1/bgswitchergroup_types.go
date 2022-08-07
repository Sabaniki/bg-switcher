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

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

type BgSwitcherGroupSpec struct {
	Groups    []Group `json:"groups"`
	MainColor string  `json:"mainColor"`
}

type Group struct {
	Color     string         `json:"color"`
	BbRouters []BbRouterSpec `json:"bbrouters"`
}

type BbRouterSpec string

type BgSwitcherGroupStatus struct {
	BbRouters []BbRouterStatus `json:"bbrouters"`
}

type BbRouterStatus struct {
	Name    string `json:"name"`
	Color   string `json:"color"`
	Created bool   `json:"created"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

type BgSwitcherGroup struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   BgSwitcherGroupSpec   `json:"spec,omitempty"`
	Status BgSwitcherGroupStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

type BgSwitcherGroupList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []BgSwitcherGroup `json:"items"`
}

func init() {
	SchemeBuilder.Register(&BgSwitcherGroup{}, &BgSwitcherGroupList{})
}
