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