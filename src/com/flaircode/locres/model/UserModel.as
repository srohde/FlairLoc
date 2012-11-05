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
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.swizframework.storage.ISharedObjectBean;
	
	public class UserModel {
		
		public static const KIND_DEVELOPER:String = "kindDeveloper";
		public static const KIND_TRANSLATOR:String = "kindTranslator";
		
		[Autowire]
		public var soBean:ISharedObjectBean;
		
		private var _flexSDKPath:String;
		
		[Bindable]
		public var sdkLocales:ArrayCollection;
		
		public function UserModel() {
		}
		
		[Bindable]
		public function get flexSDKPath() : String {
			if ( _flexSDKPath == null ) {
				var path:String = soBean.getValue( "flexSDKPath" );
				if ( path != null ) {
					var f:File = new File( path );
					if ( f.exists && f.isDirectory ) {
						_flexSDKPath = path;
						initFlexSDKLocales();
					}
				}
			}
			return _flexSDKPath;
		}
		
		public function set flexSDKPath( path : String ) : void {
			var localeDir:File = new File( path + "/frameworks/locale" );
			if ( localeDir.exists ) {
				_flexSDKPath = path;
				soBean.setValue( "flexSDKPath", path );
				initFlexSDKLocales();
			} else {
				throw new Error( path + " is not Flex SDK directory." );
			}
		}
		
		public function reset() : void {
			soBean.clear();
		}
		
		protected function initFlexSDKLocales() : void {
			var localeDir:File = new File( flexSDKPath + "/frameworks/locale" );
			var localeDirs:Array = localeDir.getDirectoryListing();
			var locales:Array = new Array();
			for each ( var f : File in localeDirs ) {
				// locale dirs have an underscore an the third position by definition
				if ( f.name.indexOf( "_" ) == 2 ) {
					locales.push( f.name );
				}
			}
			sdkLocales = new ArrayCollection( locales );
		}
	
	}
}