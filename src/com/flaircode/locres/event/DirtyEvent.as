package com.flaircode.locres.event
{
	import flash.events.Event;

	public class DirtyEvent extends Event
	{
		
		public static const DIRTY:String = "DirtyEvent.DIRTY";
		
		public function DirtyEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new DirtyEvent(type, bubbles, cancelable);
		}
		
	}
}