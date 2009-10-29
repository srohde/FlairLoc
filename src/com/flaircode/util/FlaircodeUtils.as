package com.flaircode.util {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	public class FlaircodeUtils {
		
		/* private static var laterTimer:Timer;
		
		   public static function executeLater(time:Number, callBack:Function, args:Array = null):void
		   {
		   var t:Timer = new Timer(time, 1);
		   t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void
		   {
		   callBack.apply(null, args);
		   }, false, 0, true);
		   t.start();
		 } */
		
		public static function showAlert( text : String, flags : uint = 4, closeHandler : Function = null ) : Alert {
			var title:String = "Alert";
			var parent:Sprite = null;
			var a:Alert = Alert.show( text, title, flags, parent, closeHandler );
			a.minWidth = 500;
			a.minHeight = 300;
			return a;
		}
		
		public static function showPopup( popupClass : Class, modal : Boolean = true, parent : DisplayObject = null, center : Boolean = true, width : Number = NaN, height : Number = NaN ) : IFlexDisplayObject {
			var popup:IFlexDisplayObject = new popupClass();
			
			if ( !isNaN( width ) ) {
				popup.width = width;
			}
			
			if ( !isNaN( height ) ) {
				popup.height = height;
			}
			
			if ( parent == null ) {
				parent = FlexGlobals.topLevelApplication as DisplayObject;
			}
			
			PopUpManager.addPopUp( popup, parent, modal );
			
			if ( center ) {
				PopUpManager.centerPopUp( popup );
			}
			
			return popup;
		}
		
		public static function centerToScreen( w : EventDispatcher ) : void {
			if ( w.hasOwnProperty( "width" ) && w.hasOwnProperty( "height" ) ) {
				var o:Object = w;
				var x:Number = (Capabilities.screenResolutionX - o.width) / 2;
				var y:Number =  (Capabilities.screenResolutionY - o.height) / 2;
				try {
					o.move( x, y );
				} catch ( e : Error ) {
					o.x = x;
					o.y = y;
				}
			}
		}
		
		public function FlaircodeUtils() {
		}
	
	}
}