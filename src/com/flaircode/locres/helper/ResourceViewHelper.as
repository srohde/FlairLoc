package com.flaircode.locres.helper
{
	import com.flaircode.locres.domain.Resource;
	import com.flaircode.locres.event.TranslateResourceEvent;
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.model.ResourceListModel;
	import com.flaircode.locres.view.TranslateWindow;
	import com.flaircode.locres.view.project.MultilineEditor;
	import com.flaircode.locres.view.project.ResourceListView;
	import com.flaircode.util.FlaircodeUtils;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.swizframework.Swiz;
	
	public class ResourceViewHelper
	{
		
		private static const logger:ILogger = Log.getLogger("ResourceViewHelper");
		
		[Autowire]
		public var localeModel:LocaleModel;
		
		[Autowire]
		public var resourceListModel:ResourceListModel;
		
		private var _init:Boolean = false;
		private var _view:ResourceListView;
		private var cm:ContextMenu;
		
		
		[Autowire(view="true")]
		public function set resourceListView(view:ResourceListView):void
		{
			if(view != null && !_init)
			{
				_init = true;
				_view = view;
				
				var dg:DataGrid = view.resources;
				dg.addEventListener(DataGridEvent.ITEM_EDIT_BEGIN, itemEditBeginHandler, false, 0, true);
				dg.addEventListener(ListEvent.CHANGE, resourceChangeHandler);
				dg.addEventListener(MouseEvent.RIGHT_CLICK, gridRightClickHandler);
				
				_view.autoTranslateButton.addEventListener(MouseEvent.CLICK, autoTranslate, false, 0, true)
				
			}
		}
		
		private function autoTranslate(e:Event):void
		{
			var window:TranslateWindow = new TranslateWindow();
			Swiz.getInstance().registerWindow(window);
			window.open();
			FlaircodeUtils.centerToScreen(window);
		}
		
		private function resourceChangeHandler(e:ListEvent):void
		{
			
		}
		
		private function gridRightClickHandler(e:MouseEvent):void
		{
			var resource:Resource;
			if(e.target.hasOwnProperty("data"))
			{
				resource = e.target.data as Resource;
			}
			
			if(resource != null)
			{
				_view.resources.selectedIndex = ListCollectionView(_view.resources.dataProvider).getItemIndex(resource);
			
				cm = new ContextMenu();
				var translateMenuItem:NativeMenuItem = new NativeMenuItem("Translate From", false);
				translateMenuItem.submenu = new NativeMenu();
				
				var ac:ArrayCollection = localeModel.locales;
				for each(var code:String in ac)
				{
					if(code != localeModel.selectedLocaleDir.locale)
					{
						var fromResource:Resource = localeModel.getLocaleDirByCode(code).getResourceByKey(resource.name);
						if(fromResource != null)
						{
							var label:String = code + ": " + fromResource.value;
							var localeMenuItem:NativeMenuItem = new NativeMenuItem(label);
							localeMenuItem.data = code;
							localeMenuItem.enabled = resource.value != "";
							localeMenuItem.addEventListener(Event.SELECT, translateResourceHandler);
							translateMenuItem.submenu.addItem(localeMenuItem);
						}
					}
				}
				
				cm.addItem(translateMenuItem);
				
				var devider:NativeMenuItem = new NativeMenuItem("", true);
				cm.addItem(devider);
				
				/* var showCompare:NativeMenuItem = new NativeMenuItem("Show Compare Column");
				showCompare.addEventListener(Event.SELECT, toggleShowCompare, false, 0, true);
				showCompare.checked = resourceListModel.showCompare;
				cm.addItem(showCompare); */
				
				cm.display(e.currentTarget.stage, e.stageX, e.stageY);
			}
		}
		
		private function toggleShowCompare(e:Event):void
		{
			resourceListModel.showCompare = !resourceListModel.showCompare;
		}
		
		private function translateResourceHandler(e:Event):void
		{
			var resource:Resource = _view.resources.selectedItem as Resource;
			logger.info("translate " + resource.name);
			var fromLang:String = e.currentTarget.data;
			var toLang:String = localeModel.selectedLocaleDir.locale;
			Swiz.dispatchEvent(new TranslateResourceEvent(TranslateResourceEvent.TRANSLATE, resource, fromLang, toLang));
		}
		
		private function itemEditBeginHandler(e:DataGridEvent):void
			{
				var dgir:DataGridItemRenderer = e.itemRenderer as DataGridItemRenderer;
				var resource:Resource = dgir.data as Resource;
				if(resource.isMultiline)
				{
					e.preventDefault();
					e.stopImmediatePropagation();
					var me:MultilineEditor = new MultilineEditor();
					me.resource = resource;
					me.width = 800;
					me.height = 600;
					me.open();
					FlaircodeUtils.centerToScreen(me);
				}
			}

	}
}