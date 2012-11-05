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
	import com.flaircode.locres.domain.LocaleDir;
	import com.flaircode.locres.domain.SourceKey;
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.model.SourceModel;
	import com.flaircode.locres.view.resource.LocalePreviewView;
	import com.flaircode.locres.view.source.CompileArgsWindow;
	import com.flaircode.util.FileUtils;
	import com.flaircode.util.FlaircodeUtils;
	import com.flaircode.util.LocaleUtil;
	import com.soenkerohde.ga.event.TrackActionEvent;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.StringUtil;
	
	import org.swizframework.Swiz;
	import org.swizframework.factory.IDispatcherBean;
	import org.swizframework.factory.IInitializingBean;
	import org.swizframework.storage.ISharedObjectBean;
	
	import spark.components.Window;
	
	public class LocaleController implements IInitializingBean, IDispatcherBean {
		
		private static const logger:ILogger = Log.getLogger( "LocaleController" );
		
		[Autowire]
		public var model:LocaleModel;
		
		[Autowire]
		public var sourceModel:SourceModel;
		
		[Autowire]
		public var so:ISharedObjectBean;
		
		private var _dispatcher:IEventDispatcher;
		
		public function set dispatcher( dispatcher : IEventDispatcher ) : void {
			_dispatcher = dispatcher;
		}
		
		public function LocaleController() {
		}
		
		[Mediate(event="LocaleEvent.REFRESH")]
		public function refresh() : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "refresh", "-" ) );
			initialize();
		}
		
		public function initialize() : void {
			var path:String = so.getString( "localeDirPath" );
			if ( path != null ) {
				var f:File = new File( path );
				if ( f.exists && f.isDirectory ) {
					initLocaleDir( f );
				}
			}
		}
		
		[Mediate(event="DirtyEvent.DIRTY")]
		public function dirtyHandler() : void {
			model.dirty = true;
		}
		
		[Mediate(event="LocaleEvent.CREATE", properties="locale")]
		public function createLocale( localeCode : String ) : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "create locale", localeCode ) );
			var localeDir:LocaleDir = new LocaleDir();
			localeDir.locale = localeCode;
			localeDir.resourceBundles = new ArrayCollection();
			localeDir.path = model.localeDir.nativePath + "/" + localeCode;
			localeDir.selectedResourceBundle = model.selectedResourceBundle;
			
			model.localeDirs.addItem( localeDir );
			model.locales.addItem( localeCode );
		}
		
		[Mediate(event="LocaleEvent.REMOVE", properties="locale")]
		public function removeLocale( locale : String ) : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "remove locale", locale ) );
			var ld:LocaleDir = model.getLocaleDirByCode( locale );
			
			var msg:String = "Are you sure to delete {0} with all its contents?"
			msg = StringUtil.substitute( msg, ld.path );
			Alert.show( msg, "Delete Locale", Alert.OK | Alert.CANCEL, null, function( e : CloseEvent ) : void
				{
					if ( e.detail == Alert.OK )
					{
						var index:int = model.localeDirs.getItemIndex( ld );
						model.localeDirs.removeItemAt( index );
						var f:File = new File( ld.path );
						if ( f.exists && f.isDirectory )
						{
							f.deleteDirectory( true );
						}
						
						var localeIndex:int = model.locales.getItemIndex( locale );
						model.locales.removeItemAt( localeIndex );
					}
				} );
		
		}
		
		[Mediate(event="LocaleEvent.BROWSE_LOCALE_DIR")]
		public function browseLocaleDirHandler() : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "browse", "-" ) );
			
			var f:File = new File();
			f.browseForDirectory( "Select Locale Directory" );
			f.addEventListener( Event.SELECT, onBrowseLocaleDir );
		}
		
		protected function onBrowseLocaleDir( e : Event ) : void {
			initLocaleDir( e.currentTarget as File );
		}
		
		protected function initLocaleDir( rootLocaleDir : File ) : void {
			
			// set path
			model.localeDir = rootLocaleDir;
			// store in SO
			so.setString( "localeDirPath", rootLocaleDir.nativePath );
			
			// set locales
			model.locales = LocaleUtil.getLocalesFromDir( rootLocaleDir );
			// set resource bundles
			model.resourceBundles = LocaleUtil.getResourceBundlesFromPath( rootLocaleDir, model.locales );
			
			// set selectedResourceBundle
			if ( model.resourceBundles != null && model.resourceBundles.length > 0 ) {
				model.selectedResourceBundle = model.resourceBundles.getItemAt( 0 ) as String;
			}
			
			// set localeDirs
			var localeDirs:ArrayCollection = new ArrayCollection();
			for each ( var locale : String in model.locales ) {
				var localeDir:File = rootLocaleDir.resolvePath( locale );
				if ( !localeDir.exists ) {
					throw new Error( "Locale directory does not exist " + localeDir.nativePath );
				} else {
					var ld:LocaleDir = new LocaleDir();
					ld.locale = locale;
					ld.path = model.localeDir.nativePath + "/" + locale;
					ld.resourceBundles = LocaleUtil.getResourceBundlesForLocale( rootLocaleDir, locale );
					ld.selectedResourceBundle = model.selectedResourceBundle;
					localeDirs.addItem( ld );
				}
			}
			
			model.localeDirs = localeDirs;
			
			if ( localeDirs.length > 0 ) {
				model.selectedLocaleDir = localeDirs.getItemAt( 0 ) as LocaleDir;
			}
		}
		
		[Mediate(event="LocaleEvent.SAVE_ALL")]
		public function saveAllHandler() : void {
			logger.info( "saveAll" );
			
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "save all", "-" ) );
			
			for each ( var ld : LocaleDir in model.localeDirs ) {
				if ( ld.dirty ) {
					saveLocale( ld );
				}
			}
			
			model.dirty = false;
		}
		
		[Mediate(event="LocaleEvent.SYNC_FROM_SOURCE")]
		public function syncFromSource() : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "sync from source", "-" ) );
			
			if ( model.localeDirs != null && model.localeDirs.length > 0 ) {
				for each ( var ld : LocaleDir in model.localeDirs ) {
					ld.syncWithKeys( sourceModel.keys, model.sourceSyncPrefix, model.splitCamelCase );
				}
			} else {
				
				var localeCode:String = "en_US";
				
				var keys:ArrayCollection = sourceModel.keys;
				var sourceKey:SourceKey = keys.getItemAt( 0 ) as SourceKey;
				model.locales.addItem( "en_US" );
				model.resourceBundles = new ArrayCollection();
				model.resourceBundles.addItem( sourceKey.resourceBundle );
				model.selectedResourceBundle = sourceKey.resourceBundle;
				
				var localeDir:LocaleDir = new LocaleDir();
				localeDir.locale = localeCode;
				localeDir.resourceBundles = new ArrayCollection();
				localeDir.path = model.localeDir.nativePath + "/" + localeCode;
				localeDir.selectedResourceBundle = model.selectedResourceBundle;
				
				model.localeDirs.addItem( localeDir );
				
				localeDir.syncWithKeys( sourceModel.keys, model.sourceSyncPrefix, model.splitCamelCase );
			}
		}
		
		[Mediate(event="LocaleEvent.GENERATE_COMPILE_ARGS")]
		public function generate() : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "generate compiler args", "-" ) );
			
			var w:spark.components.Window = new CompileArgsWindow();
			w.systemChrome = "none";
			w.transparent = true;
			w.type = NativeWindowType.LIGHTWEIGHT;
			Swiz.getInstance().registerWindow( w );
			w.open();
			FlaircodeUtils.centerToScreen( w );
		}
		
		[Mediate(event="LocaleEvent.PREVIEW_LOCALE")]
		public function previewLocale() : void {
			logger.info( "previewLocale" );
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "preview locale", "-" ) );
			
			var slv:LocalePreviewView = new LocalePreviewView();
			Swiz.getInstance().registerWindow( slv );
			slv.width = 800;
			slv.height = 600;
			slv.open();
			FlaircodeUtils.centerToScreen( slv );
		}
		
		[Mediate(event="LocaleDirEvent.SAVE", properties="localeDir")]
		public function saveLocale( localeDir : LocaleDir ) : void {
			logger.debug( "save " + localeDir.path );
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "save", "-" ) );
			
			var res:String = localeDir.toString();
			var f:File = new File( localeDir.path + "/" + model.selectedResourceBundle + ".properties" );
			if ( f.exists ) {
				FileUtils.writeUTFBytes( f, res );
				localeDir.dirty = false;
			} else {
				// TODO handle file does not exist
			}
			
			var stillDirty:Boolean = false;
			for each ( var ld : LocaleDir in model.localeDirs ) {
				if ( ld.dirty ) {
					stillDirty = true;
					break;
				}
			}
			
			model.dirty = stillDirty;
		}
		
		[Mediate(event="LocaleEvent.CANCEL_LOCALE")]
		public function cancelHandler() : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "LOCALE", "cancel", "-" ) );
			
			var res:String = model.selectedLocaleDir.toString();
			var filePath:String = model.localeDir.nativePath + "/"
			filePath +=  model.selectedLocaleDir.locale + "/"
			filePath += model.selectedResourceBundle + ".properties";
			var f:File = new File( filePath );
			if ( f.exists ) {
				// TODO implement cancel
			} else {
				// TODO handle file does not exist
			}
		}
		
		[Mediate(event="LocaleEvent.WRITE_LOCALE")]
		public function writeLocale() : void {
			var res:String = model.selectedLocaleDir.toString();
			var filePath:String = model.localeDir.nativePath + "/"
			filePath +=  model.selectedLocaleDir.locale + "/"
			filePath += model.selectedResourceBundle + ".properties";
			var f:File = new File( filePath );
			if ( f.exists ) {
				FileUtils.writeUTFBytes( f, res );
				model.selectedLocaleDir.dirty = false;
			} else {
				// TODO handle file does not exist
			}
		}
		
		[Mediate(event="LocaleDirEvent.CHANGE", properties="localeDir")]
		public function changeLocaleDir( localeDir : LocaleDir ) : void {
			model.selectedLocaleDir = localeDir;
		}
		
		[Mediate(event="ResourceSearchEvent.SEARCH", properties="searchQuery")]
		public function searchResource( searchQuery : String ) : void {
			model.searchResource( searchQuery );
		}
	
	}
}