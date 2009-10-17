package com.flaircode.locres.model
{
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class AppModel extends EventDispatcher
	{
		private static const logger:ILogger = Log.getLogger("AppModel");

		[Bindable]
		public var maximized:Boolean = false;
		
		[Bindable]
		public var online:Boolean = false;
		
		[Bindable]
		public var statusMsg:String = "";
		
		[Bindable]
		public var selectedLanguage:String = "en_US";
		
		public function AppModel()
		{
		}

	}
}