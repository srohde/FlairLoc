package com.flaircode.locres.event {
	import flash.events.Event;
	
	public class TrackPageActionEvent extends Event {
		
		public static const ACTION:String = "TrackPageActionEvent.ACTION";
		
		public var category:String;
		public var action:String;
		public var label:String;
		public var value:Number;
		
		public function TrackPageActionEvent( type : String, category : String, action : String, label : String, value : Number = NaN, bubbles : Boolean = false, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
			this.category = category;
			this.action = action;
			this.label = label;
			this.value = value;
		}
	}
}