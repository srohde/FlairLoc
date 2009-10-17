package scolab.flash  
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;

	import mx.events.FlexEvent;
	import mx.flash.UIMovieClip;

	public class UIMovieClip extends mx.flash.UIMovieClip
	{

		public function UIMovieClip()
		{
			super();
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
			// we need less priority then the originnal "unOverridable" handler creationCompleteHandler()  
			addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationCompleteHandler, false, -1);
		}
		private var indexesMapByFrameLabel:Object = new Object()

		private function handleCreationCompleteHandler(event:FlexEvent):void
		{

			//Here we create an index map of the FrameLabel  
			for(var i:uint = 0; i < currentLabels.length; i++)
			{
				var label:FrameLabel = currentLabels[i];
				indexesMapByFrameLabel[label.name] = label.frame
			}
		}

		private var mc:MovieClip
		private var disposeCounter:int = 0;

		override public function set currentState(value:String):void
		{
			var frameFrom:int = indexesMapByFrameLabel[currentState]
			super.currentState = value
			var frameTo:uint = indexesMapByFrameLabel[value]
			disposeCounter = Math.max(Math.max(frameFrom, frameTo) - Math.min(frameFrom, frameTo), 1)
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
		}

		override protected function enterFrameHandler(event:Event):void
		{
			super.enterFrameHandler(event);

			if (disposeCounter <= 0)
			{
				disposeCounter = 0
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
				return ;
			}

			if (disposeCounter > 0)
				disposeCounter--
		}
	}   
}