/*
Copyright 2009 Sönke Rohde

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.flaircode.locres.event
{
	import flash.events.Event;

	public class LocaleEvent extends Event
	{
		
		public static const BROWSE_LOCALE_DIR:String = "LocaleEvent.BROWSE_LOCALE_DIR";
		public static const REFRESH:String = "LocaleEvent.REFRESH";
		public static const PREVIEW_LOCALE:String = "LocaleEvent.PREVIEW_LOCALE";
		public static const WRITE_LOCALE:String = "LocaleEvent.WRITE_LOCALE";
		public static const CANCEL_LOCALE:String = "LocaleEvent.CANCEL_LOCALE";
		public static const SYNC_FROM_SOURCE:String = "LocaleEvent.SYNC_FROM_SOURCE";
		public static const GENERATE_COMPILE_ARGS:String = "LocaleEvent.GENERATE_COMPILE_ARGS";
		public static const SAVE_ALL:String = "LocaleEvent.SAVE_ALL";
		
		public static const CREATE:String = "LocaleEvent.CREATE";
		public static const REMOVE:String = "LocaleEvent.REMOVE";
		
		public var locale:String;
		
		/**
		 * 
		 * @param type
		 * @param locale only for create/remove
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function LocaleEvent(type:String, locale:String = null, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.locale = locale;
		}
		
		override public function clone():Event
		{
			return new LocaleEvent(type, locale, bubbles, cancelable);
		}
		
	}
}