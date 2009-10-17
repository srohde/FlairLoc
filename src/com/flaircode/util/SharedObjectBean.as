package com.flaircode.util
{
	import flash.net.SharedObject;
	
	public class SharedObjectBean
	{
		private var so:SharedObject;
		
		private var _path:String = "/";
		private var _name:String;
		
		public function set path(s:String):void
		{
			_path = s;
			invalidate();
		}
		
		public function set name(s:String):void
		{
			_name = s;
			invalidate();
		}
		
		public function get size():Number
		{
			if(so != null)
			{
				return so.size
			}
			return NaN;
		}
		
		public function SharedObjectBean()
		{
		}
		
		private function invalidate():void
		{
			so = SharedObject.getLocal(_name, _path);
		}
		
		public function reset():void
		{
			so.clear();
		}
		
		public function getValue(name:String, initValue:* = null):*
		{
			var o:Object = so.data;
			if(o[name] == null && initValue != null)
			{
				o[name] = initValue;
				so.flush();
			}
			
			return o[name];
		}
		
		public function setValue(name:String, value:*):void
		{
			var o:Object = so.data;
			o[name] = value;
			so.flush();
		}
		

	}
}