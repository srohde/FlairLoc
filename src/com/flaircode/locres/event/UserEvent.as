package com.flaircode.locres.event
{
	import flash.events.Event;

	public class UserEvent extends Event
	{
		
		public static const RESET:String = "com.flaircode.locres.event.UserEvent.RESET";
		public static const BROWSE_FLEX_SDK:String = "com.flaircode.locres.event.UserEvent.BROWSE_FLEX_SDK"
		
		public var value:String;
		
		public function UserEvent(type:String, value:String = null, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.value = value;
		}
		
		override public function clone():Event
		{
			return new UserEvent(type, value, bubbles, cancelable);
		}
		
	}
}