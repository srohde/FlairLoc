package com.flaircode.locres.event
{
	import flash.events.Event;

	public class SourceEvent extends Event
	{
		
		public static const BROWSE_DIR:String = "SourceEvent.BROWSE_DIR";
		public static const REFRESH:String = "SourceEvent.REFRESH";
		public static const GENERATE:String = "SourceEvent.GENERATE";
		
		public function SourceEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new SourceEvent(type, bubbles, cancelable);
		}
		
	}
}