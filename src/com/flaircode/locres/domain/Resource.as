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