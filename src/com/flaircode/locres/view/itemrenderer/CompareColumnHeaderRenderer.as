package com.flaircode.locres.view.itemrenderer
{
	import com.flaircode.locres.event.CompareLocaleEvent;
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.model.ResourceListModel;
	
	import flash.events.Event;
	
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	
	public class CompareColumnHeaderRenderer extends UIComponent implements IListItemRenderer
	{
		
		private var _init:Boolean = false;
		private var _label:Label;
		private var _comboBox:ComboBox;
		
		[Autowire]
		public function set resoureListModel(model:ResourceListModel):void
		{
			if(!_init)
			{
				_init = true;
				//BindingUtils.bindProperty(saveButton, "visible", model, "dirty");
			}
		}
		
		[Autowire]
		public function set localeModel(model:LocaleModel):void
		{
			_comboBox.dataProvider = model.locales;
		}
		
		
		public function get data():Object
		{
			return null;
		}
		
		public function set data(value:Object):void
		{
			createChildren();
			commitProperties();
		}
		
		override protected function createChildren():void
		{
			if(_comboBox == null)
			{
				_label = new Label();
				_label.text = "Compare with";
				_label.validateNow();
				addChild(_label);
				
				_comboBox = new ComboBox();
				//_comboBox.dataProvider = localeModel.locales;
				_comboBox.addEventListener(Event.CHANGE, changeHandler);
				addChild(_comboBox);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		override protected function measure():void
		{
			super.measure();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(_comboBox != null)
			{
				_label.setActualSize(unscaledWidth - 100, unscaledHeight);
				_label.move(5, 0);
				_comboBox.setActualSize(80, unscaledHeight);
				_comboBox.move(unscaledWidth - _comboBox.width - 5, 0);
			}
		}
		
		private function changeHandler(e:Event):void
		{
			var localeCode:String = _comboBox.selectedItem as String;
			dispatchEvent(new CompareLocaleEvent(CompareLocaleEvent.CHANGE, localeCode));
		}

	}
}