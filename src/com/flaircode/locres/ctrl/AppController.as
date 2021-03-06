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
	import com.flaircode.locres.event.AppEvent;
	import com.flaircode.locres.model.AppModel;
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.view.window.AboutWindow;
	import com.flaircode.locres.view.window.SettingsWindow;
	import com.flaircode.util.FlaircodeUtils;
	import com.soenkerohde.ga.event.TrackActionEvent;
	import com.soenkerohde.ga.event.TrackPageEvent;
	
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.resources.ResourceManager;
	
	import org.swizframework.Swiz;
	import org.swizframework.factory.IDispatcherBean;
	import org.swizframework.factory.IInitializingBean;
	import org.swizframework.storage.ISharedObjectBean;
	
	import spark.components.Window;
	
	public class AppController implements IInitializingBean, IDispatcherBean {
		
		private static const logger:ILogger = Log.getLogger( "AppController" );
		
		[Autowire]
		public var model:AppModel;
		
		[Autowire]
		public var localeModel:LocaleModel;
		
		[Autowire]
		public var soBean:ISharedObjectBean;
		
		protected var settingsWindow:SettingsWindow;
		
		private var _dispatcher:IEventDispatcher;
		
		public function set dispatcher( dispatcher : IEventDispatcher ) : void {
			_dispatcher = dispatcher;
		}
		
		public function AppController() {
		}
		
		public function initialize() : void {
			ResourceManager.getInstance().localeChain = ["en_US"];
			FlexGlobals.topLevelApplication.addEventListener( FlexEvent.CREATION_COMPLETE, onCC );
			FlexGlobals.topLevelApplication.addEventListener( Event.CLOSING, onClosing );
		}
		
		public function onCC( event : FlexEvent ) : void {
			FlaircodeUtils.centerToScreen( FlexGlobals.topLevelApplication.nativeWindow );
			Swiz.dispatchEvent( new AppEvent( AppEvent.INIT ) );
			_dispatcher.dispatchEvent( new TrackPageEvent( TrackPageEvent.PAGE, "/" ) );
		}
		
		public function onClosing( e : Event ) : void {
			if ( localeModel.dirty ) {
				e.preventDefault();
				Alert.show( "There are unsaved changes. If you continue these changes will be lost.", "Close", Alert.OK | Alert.CANCEL, null, closeHandler );
			}
		}
		
		protected function closeHandler( e : CloseEvent ) : void {
			if ( e.detail == Alert.OK ) {
				FlexGlobals.topLevelApplication.exit();
			}
		}
		
		private var statusTimer:Timer;
		
		[Mediate(event="FooterEvent.STATUS", properties="message,autohide")]
		public function statusHandler( message : String, autohide : Boolean ) : void {
			model.statusMsg = message;
			
			if ( statusTimer == null ) {
				statusTimer = new Timer( 3500, 1 );
				statusTimer.addEventListener( TimerEvent.TIMER_COMPLETE, function( e : Event ) : void
					{
						model.statusMsg = "";
					} );
			}
			
			if ( statusTimer.running ) {
				statusTimer.stop();
				statusTimer.reset();
			}
			
			if ( autohide ) {
				statusTimer.start();
			}
		}
		
		[Mediate(event="AppEvent.MAXIMIZE")]
		public function maximize() : void {
			var nw:NativeWindow = FlexGlobals.topLevelApplication.nativeWindow;
			if ( !model.maximized ) {
				_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "APP", "maximize", "-" ) );
				
				soBean.setValue( "windowX", nw.x );
				soBean.setValue( "windowY", nw.y );
				soBean.setValue( "windowW", nw.width );
				soBean.setValue( "windowH", nw.height );
				FlexGlobals.topLevelApplication.maximize();
			} else {
				_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "APP", "restore", "-" ) );
				
				FlexGlobals.topLevelApplication.restore();
				nw.x = soBean.getValue( "windowX" )
				nw.y = soBean.getValue( "windowY" );
				nw.height = soBean.getValue( "windowH" );
				nw.width = soBean.getValue( "windowW" );
			}
			model.maximized = !model.maximized;
		}
		
		[Mediate(event="AppEvent.ABOUT")]
		public function showAbout() : void {
			_dispatcher.dispatchEvent( new TrackPageEvent( TrackPageEvent.PAGE, "/about" ) );
			
			var w:spark.components.Window = new AboutWindow();
			w.open();
			FlaircodeUtils.centerToScreen( w );
		}
		
		[Mediate(event="AppEvent.HELP")]
		public function showHelp() : void {
			_dispatcher.dispatchEvent( new TrackPageEvent( TrackPageEvent.PAGE, "/help" ) );
			navigateToURL( new URLRequest( "http://flairloc.com" ) );
		/* var w:Window = new HelpWindow();
		   w.open();
		 FlaircodeUtils.centerToScreen(w); */
		}
		
		[Mediate(event="AppEvent.SHOW_SETTINGS")]
		public function showSettings() : void {
			_dispatcher.dispatchEvent( new TrackPageEvent( TrackPageEvent.PAGE, "/settings" ) );
			if ( settingsWindow == null ) {
				settingsWindow = new SettingsWindow();
				Swiz.getInstance().registerWindow( settingsWindow );
				FlaircodeUtils.centerToScreen( settingsWindow );
				settingsWindow.open();
			} else if ( settingsWindow.closed ) {
				settingsWindow = null;
				settingsWindow = new SettingsWindow();
				Swiz.getInstance().registerWindow( settingsWindow );
				FlaircodeUtils.centerToScreen( settingsWindow );
				settingsWindow.open();
			} else {
				settingsWindow.activate();
			}
		}
	
	}
}