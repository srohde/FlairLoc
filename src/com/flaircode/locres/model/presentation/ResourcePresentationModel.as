package com.flaircode.locres.model.presentation {
	import com.flaircode.locres.event.LocaleEvent;
	import com.flaircode.locres.event.ResourceSearchEvent;
	
	import flash.events.IEventDispatcher;
	
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