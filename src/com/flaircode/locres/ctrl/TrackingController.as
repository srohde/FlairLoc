package com.flaircode.locres.ctrl {
	import com.google.analytics.GATracker;
	import com.google.analytics.components.FlexTracker;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import org.swizframework.factory.IInitializingBean;
	
	public class TrackingController {
		
		private static const logger:ILogger = Log.getLogger( "TackingController" );
		
		private var ga:GATracker;
		
		public function TrackingController() {
		
		}
		
		[Mediate(event="AppEvent.INIT")]
		public function initialize() : void {
			var display:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			ga = new GATracker( display, "UA-11431550-1" );
		}
		
		[Mediate(event="TrackPageViewEvent.PAGE", properties="page")]
		public function trackPage( page : String ) : void {
			logger.info( "trackPageview " + page );
			ga.trackPageview( page );
		}
		
		[Mediate(event="TrackPageActionEvent.ACTION", properties="category,action,label,value")]
		public function trackEvent( category : String, action : String, label : String, value : Number ) : void {
			logger.info( "trackEvent " + category + ", " + action + ", " + label + ", " + value );
			ga.trackEvent( category, action, label, value );
		}
	}
}