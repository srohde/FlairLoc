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
package com.flaircode.locres.domain
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	[Bindable]
	public class Resource extends EventDispatcher
	{
		
		public static const CHANGE:String = "resourceChange";
		
		private var oldValue:String;
		
		private var _value:String;
		
		public function get value():String
		{
			return _value;
		}
		
		public function set value(s:String):void
		{
			var wasNull:Boolean = oldValue == null;
			oldValue = _value;
			_value = s;
			if(!wasNull && oldValue != s)
			{
				dispatchEvent(new Event(CHANGE));
			}
		}
		
		public var name:String;
		
		public var usage:uint = 0;
		
		public var comment:String;
		
		public var isMultiline:Boolean;
		
		public function Resource()
		{
		}
		

	}
}