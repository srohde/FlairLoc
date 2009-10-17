package com.flaircode.locres.view.itemrenderer
{
	import com.flaircode.locres.domain.LocaleDir;
	import com.flaircode.locres.event.LocaleDirEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	
	public class SaveButtonItemRenderer extends UIComponent implements IListItemRenderer
	{
		
		private var localeDir:LocaleDir;
		private var saveButton:Button;
		
		public function get data():Object
		{
			return localeDir;
		}
		
		public function set data(value:Object):void
		{
			localeDir = value as LocaleDir;
			createChildren();
			commitProperties();
		}
		
		public function SaveButtonItemRenderer()
		{
		}
		
		override protected function createChildren():void
		{
			if(localeDir != null)
			{
				if(saveButton == null)
				{
					saveButton = new Button();
					saveButton.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
					saveButton.addEventListener(MouseEvent.MOUSE_DOWN, overHandler);
					saveButton.addEventListener(MouseEvent.CLICK, clickHandler);
					saveButton.styleName = "saveButton";
					saveButton.setActualSize(22, 20);
					addChild(saveButton);
				}
			}
		}
		
		private function overHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			dispatchEvent(new LocaleDirEvent(LocaleDirEvent.SAVE, localeDir));
		}
		
		override protected function commitProperties():void
		{
			if(saveButton == null)
				return;
				
			if(localeDir != null)
			{
				saveButton.visible = localeDir.dirty;
			}
			else
			{
				saveButton.visible = false;
			}
		}
		
		override protected function measure() : void
		{
			measuredWidth = 22;
			measuredHeight = 20;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//move((unscaledWidth - measuredWidth) / 2, (unscaledHeight - measuredHeight) / 2);
		}

	}
}