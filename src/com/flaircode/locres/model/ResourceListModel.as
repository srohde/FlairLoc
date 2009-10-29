package com.flaircode.locres.model {
	import org.swizframework.storage.ISharedObjectBean;
	
	public class ResourceListModel {
		
		[Autowire]
		public var soBean:ISharedObjectBean;
		
		[Bindable]
		public var compareLocaleCode:String = "en_US";
		
		[Bindable]
		public function get showCompare() : Boolean {
			return soBean.getValue( "showCompare", true );
		}
		
		public function set showCompare( show : Boolean ) : void {
			soBean.setValue( "showCompare", show );
		}
		
		public function ResourceListModel() {
		}
		
		// FIXME Mediate CompareLocaleEvent.CHANGE
		//[Mediate(event="CompareLocaleEvent.CHANGE", properties="localeCode")]
		public function changeCompareLocaleCode( localeCode : String ) : void {
			compareLocaleCode = localeCode;
		}
	
	}
}