package com.flaircode.locres.event
{
	import flash.events.Event;

	public class ResourceSearchEvent extends Event
	{
		
		public static const SEARCH:String = "ResourceSearchEvent.SEARCH";
		
		public var searchQuery:String;
		
		public function ResourceSearchEvent(type:String, searchQuery:String, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.searchQuery = searchQuery;
		}
		
		override public function clone():Event
		{
			return new ResourceSearchEvent(type, searchQuery, bubbles, cancelable);
		}
		
	}
}