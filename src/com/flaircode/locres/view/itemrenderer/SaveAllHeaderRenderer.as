package com.flaircode.locres.view.itemrenderer {
	import com.flaircode.locres.event.LocaleEvent;
	import com.flaircode.locres.model.presentation.LocalePresentationModel;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Button;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	
	public class SaveAllHeaderRenderer extends UIComponent implements IListItemRenderer {
		
		[Bindable]
		[Autowire(bean="localePModel", property="dirty")]
		public var dirty:Boolean;
		
		private var saveButton:Button;
		
		public function get data() : Object {
			return null;
		}
		
		public function set data( value : Object ) : void {
			createChildren();
			commitProperties();
		}
		
		public function SaveAllHeaderRenderer() {
			super();
		}
		
		
		override protected function createChildren() : void {
			if ( saveButton == null ) {
				saveButton = new Button();
				saveButton.toolTip = resourceManager.getString( 'lr', '$LR/Common/SaveAll' );
				saveButton.addEventListener( MouseEvent.CLICK, clickHandler );
				saveButton.styleName = "saveButton";
				saveButton.setActualSize( 22, 20 );
				saveButton.visible = false;
				addChild( saveButton );
				BindingUtils.bindProperty( saveButton, "visible", this, "dirty" );
			}
		}
		
		override protected function commitProperties() : void {
			super.commitProperties();
		}
		
		override protected function measure() : void {
			measuredWidth = 22;
			measuredHeight = 20;
		}
		
		private function clickHandler( e : MouseEvent ) : void {
			dispatchEvent( new LocaleEvent( LocaleEvent.SAVE_ALL ) );
		}
	
	
	}
}