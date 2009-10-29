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