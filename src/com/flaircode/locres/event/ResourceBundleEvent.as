package com.flaircode.locres.event
{
	import flash.events.Event;
	
	public class ResourceBundleEvent extends Event
	{
		
		public static const CREATE:String = "ResourceBundleEvent.CREATE";
		public static const ADD:String = "ResourceBundleEvent.ADD";
		public static const REMOVE:String = "ResourceBundleEvent.REMOVE";
		
		public var resourceBundle:String;
		
		public function ResourceBundleEvent(type:String, resourceBundle:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.resourceBundle = resourceBundle;
		}
		
		override public function clone():Event
		{
			return new ResourceBundleEvent(type, resourceBundle, bubbles, cancelable);
		}
		
	}
}