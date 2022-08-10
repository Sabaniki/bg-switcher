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

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// BgSwitcherCanarySpec defines the desired state of BgSwitcherCanary
type BgSwitcherCanarySpec struct {
	Groups    []ColorGroup `json:"groups"`
	MainColor string       `json:"mainColor"`
	Duration  int          `json:"duration"` //秒
	Variation int          `json:"variation"`
}

type ColorGroup struct {
	Color         string         `json:"color"`
	BbRouterNames []BbRouterSpec `json:"bbrouters"`
}

// BgSwitcherCanaryStatus defines the observed state of BgSwitcherCanary
type BgSwitcherCanaryStatus struct {
	Groups        []Group     `json:"groups"`
	MainColor     string      `json:"mainColor"`
	AllCreated    bool        `json:"allCreated"`
	NextTimestamp metav1.Time `json:"nextTimeStamp"`
	LastTimestamp metav1.Time `json:"lastTimeStamp"`
	Spent         int         `json:"spent"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// BgSwitcherCanary is the Schema for the bgswitchercanaries API
type BgSwitcherCanary struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   BgSwitcherCanarySpec   `json:"spec,omitempty"`
	Status BgSwitcherCanaryStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// BgSwitcherCanaryList contains a list of BgSwitcherCanary
type BgSwitcherCanaryList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []BgSwitcherCanary `json:"items"`
}

func init() {
	SchemeBuilder.Register(&BgSwitcherCanary{}, &BgSwitcherCanaryList{})
}
