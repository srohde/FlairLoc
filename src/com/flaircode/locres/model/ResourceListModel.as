package com.flaircode.locres.model
{
	import com.flaircode.util.SharedObjectBean;
	
	public class ResourceListModel
	{
		
		[Autowire]
		public var soBean:SharedObjectBean;
		
		[Bindable]
		public var compareLocaleCode:String = "en_US";
		
		[Bindable]
		public function get showCompare():Boolean
		{
			return soBean.getValue("showCompare", true);
		}
		
		public function set showCompare(show:Boolean):void
		{
			soBean.setValue("showCompare", show);
		}
		
		public function ResourceListModel()
		{
		}
		
		[Mediate(event="CompareLocaleEvent.CHANGE", properties="localeCode")]
		public function changeCompareLocaleCode(localeCode:String):void
		{
			compareLocaleCode = localeCode;
		}

	}
}