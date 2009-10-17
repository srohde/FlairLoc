package com.flaircode.locres.event
{
	import flash.events.Event;

	public class FooterEvent extends Event
	{
		
		public static const STATUS:String = "FooterEvent.STATUS";
		
		public var message:String;
		public var autohide:Boolean;
		
		public function FooterEvent(type:String, message:String, autohide:Boolean = true, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.message = message;
			this.autohide = autohide;
		}
		
		override public function clone():Event
		{
			return new FooterEvent(type, message, autohide, bubbles, cancelable);
		} 
		
	}
}