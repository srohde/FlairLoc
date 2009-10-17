package com.flaircode.locres.event
{
	import com.flaircode.locres.domain.LocaleDir;
	
	import flash.events.Event;

	public class LocaleDirEvent extends Event
	{
		
		public static const CHANGE:String = "LocaleDirEvent.CHANGE";
		public static const SAVE:String = "LocaleDirEvent.SAVE";
		
		public var localeDir:LocaleDir;
		
		public function LocaleDirEvent(type:String, localeDir:LocaleDir, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.localeDir = localeDir;
		}
		
		override public function clone():Event
		{
			return new LocaleDirEvent(type, localeDir, bubbles, cancelable);
		}
		
	}
}