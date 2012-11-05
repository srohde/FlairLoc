/*
Copyright 2009 Sönke Rohde

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
package com.flaircode.locres.ctrl {
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.view.locale.ResourceBundleCreateView;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class ResourceBundleController {
		
		[Autowire]
		public var localeModel:LocaleModel;
		
		public function ResourceBundleController() {
		}
		
		
		[Mediate(event="ResourceBundleEvent.CREATE")]
		public function creareResourceBundle() : void {
			if ( localeModel.resourceBundles.length == 0 ) {
				var tw:TitleWindow = new ResourceBundleCreateView();
				PopUpManager.addPopUp( tw, FlexGlobals.topLevelApplication as DisplayObject, true );
				PopUpManager.centerPopUp( tw );
			} else {
				Alert.show( "This is a beta version which currently only supports one resource bundle", "FlairLoc Beta" );
			}
		}
		
		[Mediate(event="ResourceBundleEvent.ADD", properties="resourceBundle")]
		public function addResourceBundle( rb : String ) : void {
			if ( localeModel.resourceBundles == null ) {
				localeModel.resourceBundles = new ArrayCollection();
			}
			localeModel.resourceBundles.addItem( rb );
			if ( localeModel.selectedResourceBundle == null ) {
				localeModel.selectedResourceBundle = rb;
			}
		}
		
		[Mediate(event="ResourceBundleEvent.REMOVE", properties="resourceBundle")]
		public function removeResourceBundle( rb : String ) : void {
		
		}
	}
}