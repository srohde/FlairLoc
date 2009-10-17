package com.flaircode.locres.event
{
	import flash.events.Event;

	public class AppEvent extends Event
	{
		
		public static const INIT:String = "AppEvent.INIT";
		public static const MAXIMIZE:String = "AppEvent.MAXIMIZE";
		public static const RESTORE:String = "AppEvent.RESTORE";
		public static const SHOW_SETTINGS:String = "AppEvent.SHOW_SETTINGS";
		public static const ABOUT:String = "AppEvent.ABOUT";
		public static const HELP:String = "AppEvent.HELP	";
		
		public function AppEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new AppEvent(type, bubbles, cancelable);
		}
		
	}
}