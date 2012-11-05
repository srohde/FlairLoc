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
	import com.flaircode.locres.event.SourceEvent;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.swizframework.factory.IDispatcherBean;
	
	public class SourcePresentationModel implements IDispatcherBean {
		
		private var _sourceDir:File;
		
		[Bindable]
		[Autowire(bean="sourceModel", property="sourceDir")]
		public function get sourceDir() : File {
			return _sourceDir;
		}
		
		public function set sourceDir( value : File ) : void {
			_sourceDir = value;
			if ( value != null ) {
				sourceDirLabel = ".../" + value.parent.name + "/" + value.name;
				sourceDirPath = value.nativePath;
			}
			
			enabled = value != null;
		}
		
		[Bindable]
		public var sourceDirLabel:String;
		
		[Bindable]
		public var sourceDirPath:String;
		
		[Bindable]
		public var enabled:Boolean = false;
		
		[Bindable]
		[Autowire(bean="sourceModel", property="sourceKey", twoWay="true")]
		public var sourceKey:String;
		
		[Bindable]
		[Autowire(bean="sourceModel", property="keys")]
		public var keys:ArrayCollection;
		
		[Bindable]
		[Autowire(bean="sourceModel", property="loc")]
		public var loc:uint;
		
		[Bindable]
		[Autowire(bean="sourceModel", property="sourceFiles")]
		public var sourceFiles:ArrayCollection;
		
		private var _dispatcher:IEventDispatcher
		
		public function set dispatcher( dispatcher : IEventDispatcher ) : void {
			_dispatcher = dispatcher;
		}
		
		public function SourcePresentationModel() {
		}
		
		public function changeSourceKey( key : String ) : void {
			sourceKey = key;
			_dispatcher.dispatchEvent( new SourceEvent( SourceEvent.KEY_CHANGE ) )
		}
		
		public function refresh() : void {
			_dispatcher.dispatchEvent( new SourceEvent( SourceEvent.REFRESH ) )
		}
		
		public function browseSourceDir() : void {
			_dispatcher.dispatchEvent( new SourceEvent( SourceEvent.BROWSE_DIR ) );
		}
	}
}