package com.flaircode.locres.event {
	import flash.events.Event;
	
	public class TrackPageViewEvent extends Event {
		
		public static const PAGE:String = "TrackPageViewEvent.PAGE";
		
		public var page:String;
		
		public function TrackPageViewEvent( type : String, page : String, bubbles : Boolean = false, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
			this.page = page;
		}
	}
}