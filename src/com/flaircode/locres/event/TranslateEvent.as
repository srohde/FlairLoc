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