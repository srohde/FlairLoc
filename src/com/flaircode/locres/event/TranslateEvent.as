package com.flaircode.locres.event
{
	import com.flaircode.locres.domain.LocaleDir;
	
	import flash.events.Event;

	public class TranslateEvent extends Event
	{
		
		public static const TRANSLATE:String = "TranslateEvent.TRANSLATE";
		
		public var localeDir:LocaleDir;
		public var fromLang:String;
		
		public function TranslateEvent(type:String, localeDir:LocaleDir, fromLang:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.localeDir = localeDir;
			this.fromLang = fromLang;
		}
		
		override public function clone():Event
		{
			return new TranslateEvent(type, localeDir, fromLang, bubbles, cancelable);
		}
		
	}
}