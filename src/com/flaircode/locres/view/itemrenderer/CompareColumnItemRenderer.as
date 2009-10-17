package com.flaircode.locres.view.itemrenderer
{
	import com.flaircode.locres.domain.LocaleDir;
	import com.flaircode.locres.domain.Resource;
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.model.ResourceListModel;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;

	public class CompareColumnItemRenderer extends UIComponent implements IListItemRenderer
	{
		private var _init:Boolean = false;
		private var _label:Label;
		private var _resource:Resource;
		private var _compareResource:Resource;
		private var _localeModel:LocaleModel;
		
		[Autowire]
		public function set localeModel(model:LocaleModel):void
		{
			_localeModel = model;
			compareLocaleCode = LocaleDir(model.localeDirs.getItemAt(0)).locale;
		}
		
		[Autowire]
		public function set resoureListModel(model:ResourceListModel):void
		{
			if(!_init)
			{
				_init = true;
				BindingUtils.bindProperty(this, "compareLocaleCode", model, "compareLocaleCode");
			}
		}
		
		public function set compareLocaleCode(localeCode:String):void
		{
			if(_resource != null && _localeModel != null)
			{
				var compareLocaleDir:LocaleDir = _localeModel.getLocaleDirByCode(localeCode);
				if(compareLocaleDir != null)
				{
					_compareResource = compareLocaleDir.getResourceByKey(_resource.name);
					invalidateProperties();
				}
			}
		}
		
		public function get data():Object
		{
			return _resource;
		}
		
		public function set data(value:Object):void
		{
			if(value != null)
			{
				_resource = value as Resource;
				
				//_compareResource = localeModel.getLocaleDirByCode("en_US").getResourceByKey(_resource.name);
				
				createChildren();
				//commitProperties();
			}
		}
		
		public function CompareColumnItemRenderer()
		{
		}
		
		
		override protected function createChildren():void
		{
			if(_label == null)
			{
				_label = new Text();
				_label.setStyle("fontWeight", "normal");
				addChild(_label);
			}
		}
		
		override protected function commitProperties():void
		{
			if(_compareResource != null)
			{
				_label.text = _compareResource.value;
			}
		}
		
		override protected function measure():void
		{
			super.measure();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(_label != null)
			{
				_label.move(5, 0)
				_label.setActualSize(unscaledWidth, unscaledHeight);
			}
		}


		
	}
}