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
package com.flaircode.locres.helper {
	import com.flaircode.locres.dao.ILocalesDAO;
	import com.flaircode.locres.domain.Locale;
	import com.flaircode.locres.domain.LocaleDir;
	import com.flaircode.locres.event.LocaleDirEvent;
	import com.flaircode.locres.event.LocaleEvent;
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.view.locale.LocaleView;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.swizframework.Swiz;
	
	public class LocaleViewHelper {
		
		private static const logger:ILogger = Log.getLogger( "LocaleViewHelper" );
		
		[Autowire]
		public var localeModel:LocaleModel;
		
		[Autowire]
		public var localeDAO:ILocalesDAO;
		
		private var _init:Boolean = false;
		private var _view:LocaleView;
		
		private var cm:ContextMenu;
		
		[Autowire(view="true")]
		public function set projectView( view : LocaleView ) : void {
			if ( view != null && !_init ) {
				_init = true;
				_view = view;
				
				view.addLocaleButton.addEventListener( MouseEvent.CLICK, addLocaleHandler );
				view.localeGrid.addEventListener( MouseEvent.RIGHT_CLICK, gridRightClickHandler );
			}
		}
		
		public function LocaleViewHelper() {
		}
		
		private function addLocaleHandler( e : MouseEvent ) : void {
			cm = new ContextMenu();
			cm.items = getAddAbleLocales();
			cm.display( e.currentTarget.stage, e.stageX, e.stageY );
		}
		
		private function gridRightClickHandler( e : MouseEvent ) : void {
			var ld:LocaleDir;
			if ( e.target.hasOwnProperty( "data" ) ) {
				ld = e.target.data as LocaleDir;
			}
			if ( ld != null ) {
				_view.localeGrid.selectedIndex = ArrayCollection( _view.localeGrid.dataProvider ).getItemIndex( ld );
			}
			
			cm = new ContextMenu();
			var addMenu:NativeMenuItem = new NativeMenuItem( "Add Locale", false );
			addMenu.submenu = new NativeMenu();
			addMenu.submenu.items = getAddAbleLocales();
			cm.addItem( addMenu );
			
			
			if ( ld != null ) {
				cm.addItem( new NativeMenuItem( "", true ) );
				
				var removeMenu:NativeMenuItem = new NativeMenuItem( "Delete " + ld.locale + " ..." );
				removeMenu.data = ld;
				removeMenu.addEventListener( Event.SELECT, onRemoveLocale );
				cm.addItem( removeMenu );
			}
			
			cm.display( e.currentTarget.stage, e.stageX, e.stageY );
		}
		
		public function getAddAbleLocales() : Array {
			var result:Array = new Array();
			var ac:ArrayCollection = localeDAO.getLocales();
			for each ( var locale : Locale in ac ) {
				var nmi:NativeMenuItem = new NativeMenuItem( locale.name + " (" + locale.code + ")" );
				nmi.data = locale.code;
				if ( hasLocale( locale ) ) {
					nmi.checked = true;
					nmi.enabled = false;
				}
				nmi.addEventListener( Event.SELECT, onAddLocale, false, 0, true );
				result.push( nmi );
			}
			return result;
		}
		
		private function hasLocale( locale : Locale ) : Boolean {
			for each ( var s : String in localeModel.locales ) {
				if ( s == locale.code ) {
					return true;
				}
			}
			return false;
		}
		
		private function onAddLocale( e : Event ) : void {
			logger.debug( "onAddLocale " + e.currentTarget.data );
			var localeCode:String = e.currentTarget.data;
			Swiz.dispatchEvent( new LocaleEvent( LocaleEvent.CREATE, localeCode ) );
		}
		
		private function onRemoveLocale( e : Event ) : void {
			var ld:LocaleDir = NativeMenuItem( e.currentTarget ).data as LocaleDir;
			Swiz.dispatchEvent( new LocaleEvent( LocaleEvent.REMOVE, ld.locale ) );
		}
		
		public function getTranslateAbleLocalesForLocale( localeCode : String ) : Array {
			var result:Array = new Array();
			var ac:ArrayCollection = localeDAO.getLocales();
			for each ( var locale : Locale in ac ) {
				if ( hasLocale( locale ) && localeCode != locale.code ) {
					result.push( locale.code );
				}
			}
			return result;
		}
		
		public function getSyncAbleLocalesForLocale( localeCode : String ) : Array {
			var result:Array = new Array();
			var ac:ArrayCollection = localeDAO.getLocales();
			for each ( var locale : Locale in ac ) {
				var nmi:NativeMenuItem = new NativeMenuItem( locale.name + " (" + locale.code + ")" );
				if ( hasLocale( locale ) && localeCode != locale.code ) {
					nmi.data = locale.code;
					nmi.addEventListener( Event.SELECT, onSyncLocale, false, 0, true );
					result.push( nmi );
				}
			}
			return result;
		}
		
		private function onSyncLocale( e : Event ) : void {
			var code:String = NativeMenuItem( e.currentTarget ).data.toString();
			var ld:LocaleDir = _view.localeGrid.selectedItem as LocaleDir;
			logger.debug( "onSyncLocale " + ld.locale + " from " + code );
		}
	
	}
}