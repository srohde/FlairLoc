package com.flaircode.locres.event
{
	import com.flaircode.locres.domain.Resource;
	
	import flash.events.Event;

	public class TranslateResourceEvent extends Event
	{
		public static const TRANSLATE:String = "TranslateResourceEvent.TRANSLATE";
		
		public var resource:Resource;
		public var fromLang:String;
		public var toLang:String;
		
		public function TranslateResourceEvent(type:String, resource:Resource, fromLang:String, toLang:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.resource = resource;
			this.fromLang = fromLang;
			this.toLang = toLang;
		}
		
		override public function clone():Event
		{
			return new TranslateResourceEvent(type, resource, fromLang, toLang, bubbles, cancelable);
		}
		
	}
}