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
	import com.flaircode.locres.model.UserModel;
	import com.flaircode.util.FlaircodeUtils;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import org.swizframework.storage.ISharedObjectBean;
	
	public class UserController {
		
		[Autowire]
		public var soBean:ISharedObjectBean;
		
		[Autowire]
		public var userModel:UserModel;
		
		public function UserController() {
		}
		
		[Mediate(event="UserEvent.RESET")]
		public function reset() : void {
			userModel.reset();
		}
		
		[Mediate(event="UserEvent.BROWSE_FLEX_SDK")]
		public function browseFlexSDK() : void {
			var f:File = new File();
			f.browseForDirectory( "Select Flex SDK Directory" );
			f.addEventListener( Event.SELECT, onSelectFlexSDK );
		}
		
		private function onSelectFlexSDK( e : Event ) : void {
			var dir:File = e.currentTarget as File;
			
			
			
			try {
				userModel.flexSDKPath = dir.nativePath;
			} catch ( e : Error ) {
				FlaircodeUtils.showAlert( "The directory is not the Flex SDK directory. It should similar to .../sdks/3.2.0" );
			}
		
		}
	
	}
}