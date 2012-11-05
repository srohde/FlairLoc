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
	
	import com.flaircode.locres.view.window.UpdateWindow;
	import com.soenkerohde.desktop.ISwizUpdateBean;
	import com.soenkerohde.desktop.event.OnlineEvent;
	import com.soenkerohde.desktop.event.UpdateEvent;
	
	import org.swizframework.Swiz;
	
	import spark.components.Window;
	
	public class UpdateController {
		
		[Autowire]
		public function set updateBean( bean : ISwizUpdateBean ) : void {
			bean.addEventListener( UpdateEvent.VERSION_INFO, versionInfoHandler, false, 0, true );
			bean.addEventListener( UpdateEvent.UPDATE, updateHandler, false, 0, true );
			bean.addEventListener( OnlineEvent.CHANGE, onlineHandler, false, 0, true );
		}
		
		protected function versionInfoHandler( event : UpdateEvent ) : void {
			// when locale and remote version are different show update window
			if ( event.updateInfo.localVersion != event.updateInfo.remoteVersion ) {
				var updateWindow:Window = new UpdateWindow();
				Swiz.registerWindow( updateWindow );
				updateWindow.open();
				updateWindow.move( 50, 50 );
			}
		}
		
		protected function updateHandler( event : UpdateEvent ) : void {
			// prevent automatic update and wait for user to invoke
			event.preventDefault();
		}
		
		protected function onlineHandler( event : OnlineEvent ) : void {
			var online:Boolean = event.online;
			// TODO handle online status
		}
	
	}
}