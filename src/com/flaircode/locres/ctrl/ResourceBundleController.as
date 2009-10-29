package com.flaircode.locres.ctrl {
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.view.ResourceBundleCreateView;
	
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