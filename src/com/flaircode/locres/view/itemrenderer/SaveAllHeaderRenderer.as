package com.flaircode.locres.view.itemrenderer
{
	import com.flaircode.locres.event.LocaleEvent;
	import com.flaircode.locres.model.LocaleModel;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Button;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;

	public class SaveAllHeaderRenderer extends UIComponent implements IListItemRenderer
	{
		[Autowire]
		public function set localeModel(model:LocaleModel):void
		{
			if(!_init)
			{
				_init = true;
				BindingUtils.bindProperty(saveButton, "visible", model, "dirty");
			}
		}
		
		private var saveButton:Button;
		private var _init:Boolean = false;
		
		public function get data():Object
		{
			return null;
		}
		
		public function set data(value:Object):void
		{
			createChildren();
			commitProperties();
		}
		
		public function SaveAllHeaderRenderer()
		{
			super();
		}

		
		override protected function createChildren():void
		{
			if(saveButton == null)
			{
				saveButton = new Button();
				saveButton.toolTip = resourceManager.getString('lr', '$LR/Common/SaveAll');
				saveButton.addEventListener(MouseEvent.CLICK, clickHandler);
				saveButton.styleName = "saveButton";
				saveButton.setActualSize(22, 20);
				addChild(saveButton);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		override protected function measure():void
		{
			measuredWidth = 22;
			measuredHeight = 20;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			dispatchEvent(new LocaleEvent(LocaleEvent.SAVE_ALL));
		}
		
		
	}
}