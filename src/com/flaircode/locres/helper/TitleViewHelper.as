package com.flaircode.locres.helper {
	import com.flaircode.locres.model.AppModel;
	import com.flaircode.locres.view.TitleView;
	
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	
	import mx.core.FlexGlobals;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class TitleViewHelper {
		
		private var _init:Boolean = false;
		private var cm:ContextMenu;
		
		[Autowire]
		public var appModel:AppModel;
		
		[Autowire(view="true")]
		public function set titleView( view : TitleView ) : void {
			if ( view != null && !_init ) {
				_init = true;
					//view.languageLabel.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			}
		}
		
		public function TitleViewHelper() {
		}
		
		private function downHandler( e : MouseEvent ) : void {
			cm = new ContextMenu();
			
			var result:Array = new Array();
			var languages:Array = ["en_US", "de_DE", "pt_BR"];
			for each ( var lang : String in languages ) {
				var nmi:NativeMenuItem = new NativeMenuItem( lang );
				nmi.data = lang;
				if ( appModel.selectedLanguage == lang ) {
					nmi.checked = true;
					nmi.enabled = false;
				}
				nmi.addEventListener( Event.SELECT, langChangeHandler, false, 0, true );
				result.push( nmi );
			}
			
			cm.items = result;
			cm.display( FlexGlobals.topLevelApplication.stage, e.stageX, e.stageY );
		}
		
		private function langChangeHandler( e : Event ) : void {
			var localeCode:String = e.currentTarget.data;
			appModel.selectedLanguage = localeCode;
			var rm:IResourceManager = ResourceManager.getInstance();
			rm.localeChain = [localeCode];
		}
	
	}
}