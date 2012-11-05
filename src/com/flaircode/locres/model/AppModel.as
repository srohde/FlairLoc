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
package com.flaircode.locres.model {
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class AppModel extends EventDispatcher {
		private static const logger:ILogger = Log.getLogger( "AppModel" );
		
		[Bindable]
		public var maximized:Boolean = false;
		
		// TODO add online chekc
		[Bindable]
		public var online:Boolean = true;
		
		[Bindable]
		public var statusMsg:String = "";
		
		[Bindable]
		public var selectedLanguage:String = "en_US";
		
		public function AppModel() {
		}
	
	}
}