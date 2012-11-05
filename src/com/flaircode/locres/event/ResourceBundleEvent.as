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