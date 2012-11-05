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