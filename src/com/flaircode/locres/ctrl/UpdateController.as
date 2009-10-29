package com.flaircode.locres.ctrl {
	import com.flaircode.locres.view.window.UpdateWindow;
	
	import org.swizframework.Swiz;
	import org.swizframework.desktop.ISwizUpdateBean;
	import org.swizframework.desktop.event.UpdateEvent;
	
	import spark.components.Window;
	
	public class UpdateController {
		
		private var updateWindow:Window;
		
		[Autowire(id="swizUpdateBean")]
		public function set updateBean( bean : ISwizUpdateBean ) : void {
			bean.addEventListener( org.swizframework.desktop.event.UpdateEvent.VERSION_INFO, function( e : UpdateEvent ) : void
				{
					if ( e.updateInfo.localVersion != e.updateInfo.remoteVersion )
					{
						updateWindow = new UpdateWindow();
						Swiz.registerWindow( updateWindow );
						updateWindow.open();
						updateWindow.move( 50, 50 );
					}
				} );
			
			bean.addEventListener( UpdateEvent.UPDATE, function( e : UpdateEvent ) : void
				{
					e.preventDefault();
				} );
		}
		
		public function UpdateController() {
		}
	
	
	}
}