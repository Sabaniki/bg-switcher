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

type ColorGroup struct {
	Color  string `json:"color"`
	Weight int    `json:"weight"`
}

// type PeerTo struct {
// 	Name  string `json:"name"`
// 	Color string `json:"color"`
// }

// BgSwitcherSpec defines the desired state of BgSwitcher
type BgSwitcherSpec struct {
	Groups []ColorGroup `json:"groups"`
	// Peers  []PeerTo     `json:"peers"`
}

// BgSwitcherStatus defines the observed state of BgSwitcher
type BgSwitcherStatus struct {
	Groups []ColorGroup `json:"groups"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// BgSwitcher is the Schema for the bgswitchers API
type BgSwitcher struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   BgSwitcherSpec   `json:"spec,omitempty"`
	Status BgSwitcherStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// BgSwitcherList contains a list of BgSwitcher
type BgSwitcherList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []BgSwitcher `json:"items"`
}

func init() {
	SchemeBuilder.Register(&BgSwitcher{}, &BgSwitcherList{})
}
