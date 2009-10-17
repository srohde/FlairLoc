package com.flaircode.locres.event
{
	import flash.events.Event;

	public class CompareLocaleEvent extends Event
	{
		
		public static const CHANGE:String = "CompareLocaleEvent.CHANGE";
		
		public var localeCode:String;
		
		public function CompareLocaleEvent(type:String, localeCode:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.localeCode = localeCode;
		}
		
		override public function clone():Event
		{
			return new CompareLocaleEvent(type, localeCode, bubbles, cancelable);
		}
		
	}
}