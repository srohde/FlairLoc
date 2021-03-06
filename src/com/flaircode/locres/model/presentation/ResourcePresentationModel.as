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
package com.flaircode.locres.model.presentation {
	import com.flaircode.locres.event.LocaleEvent;
	import com.flaircode.locres.event.ResourceSearchEvent;
	import com.flaircode.locres.view.resource.TranslateWindow;
	import com.flaircode.util.FlaircodeUtils;
	import com.soenkerohde.ga.event.TrackPageEvent;
	
	import flash.events.IEventDispatcher;
	
	import org.swizframework.Swiz;
	import org.swizframework.factory.IDispatcherBean;
	
	public class ResourcePresentationModel implements IDispatcherBean {
		
		[Bindable]
		[Autowire(bean="appModel", property="online")]
		public var online:Boolean;
		
		
		private var _dispatcher:IEventDispatcher;
		
		public function set dispatcher( dispatcher : IEventDispatcher ) : void {
			_dispatcher = dispatcher;
		}
		
		public function ResourcePresentationModel() {
		}
		
		public function autoTranslate() : void {
			_dispatcher.dispatchEvent( new TrackPageEvent( TrackPageEvent.PAGE, "/autotranslate" ) );
			
			var window:TranslateWindow = new TranslateWindow();
			Swiz.getInstance().registerWindow( window );
			window.open();
			FlaircodeUtils.centerToScreen( window );
		}
		
		public function save() : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.WRITE_LOCALE ) );
		}
		
		public function cancel() : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.CANCEL_LOCALE ) );
		}
		
		public function preview() : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.PREVIEW_LOCALE ) );
		}
		
		public function search( searchTerm : String ) : void {
			_dispatcher.dispatchEvent( new ResourceSearchEvent( ResourceSearchEvent.SEARCH, searchTerm ) )
		}
	}
}