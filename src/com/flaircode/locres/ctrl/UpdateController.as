package com.flaircode.locres.ctrl
{
	import com.flaircode.locres.model.AppModel;
	import com.flaircode.locres.view.UpdateWindow;
	
	import mx.core.Window;
	
	import org.swizframework.Swiz;
	import org.swizframework.desktop.ISwizUpdateBean;
	import org.swizframework.desktop.OnlineEvent;
	import org.swizframework.desktop.UpdateEvent;
	
	public class UpdateController
	{
		
		private var updateWindow:Window;
		
		[Autowire]
		public var appModel:AppModel;
		
		[Autowire(id="swizUpdateBean")]
		public function set updateBean(bean:ISwizUpdateBean):void
		{
			bean.addEventListener(UpdateEvent.VERSION_INFO, function(e:UpdateEvent):void
			{
				//e.preventDefault();
				if(e.updateInfo.localVersion != e.updateInfo.remoteVersion)
				{
					updateWindow = new UpdateWindow();
					Swiz.getInstance().registerWindow(updateWindow);
					updateWindow.open();
					updateWindow.move(50, 50);
				}
			});
			
			bean.addEventListener(UpdateEvent.UPDATE, function(e:UpdateEvent):void
			{
				e.preventDefault();
			});
			
			bean.addEventListener(OnlineEvent.CHANGE, function(e:OnlineEvent):void
			{
				appModel.online = e.online;
			});
		}
		
		public function UpdateController()
		{
		}


	}
}