package com.flaircode.locres.model.presentation {
	import com.flaircode.locres.event.LocaleEvent;
	import com.flaircode.locres.event.ResourceBundleEvent;
	
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.swizframework.factory.IDispatcherBean;
	
	public class LocalePresentationModel implements IDispatcherBean {
		
		[Bindable]
		[Autowire(bean="localeModel", property="dirty", twoWay="true")]
		public var dirty:Boolean;
		
		[Bindable]
		public var localeDirPath : String;
		
		[Bindable]
		public var enabled:Boolean = false;
		
		[Bindable]
		public var localeDirLabel:String;
		
		[Bindable]
		[Autowire(bean="localeModel", property="resourceBundles")]
		public var resourceBundles:ArrayCollection;
		
		[Bindable]
		[Autowire(bean="localeModel", property="localeDirs")]
		public var localeDirs:ArrayCollection;
		
		private var _localeDir:File;
		
		[Bindable]
		[Autowire(bean="localeModel", property="localeDir")]
		public function get localeDir() : File {
			return _localeDir;
		}
		
		public function set localeDir( value : File ) : void {
			_localeDir = value;
			if ( value != null ) {
				localeDirLabel = ".../" + localeDir.parent.name + "/" + localeDir.name;
				localeDirPath = localeDir.nativePath;
			}
			enabled = value != null;
		}
		
		
		[Bindable]
		[Autowire(bean="localeModel", property="selectedResourceBundleIndex")]
		public var selectedResourceBundleIndex:int;
		
		private var _dispatcher:IEventDispatcher
		
		public function set dispatcher( dispatcher : IEventDispatcher ) : void {
			_dispatcher = dispatcher;
		}
		
		public function LocalePresentationModel() {
		}
		
		public function refresh() : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.REFRESH ) )
		}
		
		public function browseLocaleDir() : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.BROWSE_LOCALE_DIR ) )
		}
		
		public function removeLocale( locale : String ) : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.REMOVE, locale ) );
		}
		
		public function syncFromSource() : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.SYNC_FROM_SOURCE ) );
		}
		
		public function generateCompilerArgs() : void {
			_dispatcher.dispatchEvent( new LocaleEvent( LocaleEvent.GENERATE_COMPILE_ARGS ) );
		}
		
		public function createResourceBundle() : void {
			_dispatcher.dispatchEvent( new ResourceBundleEvent( ResourceBundleEvent.CREATE, null ) )
		}
		
		public function removeResourceBundle( resourceBundle : String ) : void {
			_dispatcher.dispatchEvent( new ResourceBundleEvent( ResourceBundleEvent.REMOVE, resourceBundle ) )
		}
	
	
	
	}
}