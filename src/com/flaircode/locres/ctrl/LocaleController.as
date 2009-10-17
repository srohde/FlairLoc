package com.flaircode.locres.ctrl
{
	import com.flaircode.locres.domain.LocaleDir;
	import com.flaircode.locres.domain.SourceKey;
	import com.flaircode.locres.model.LocaleModel;
	import com.flaircode.locres.model.SourceModel;
	import com.flaircode.locres.view.project.LocalePreviewView;
	import com.flaircode.locres.view.source.CompileArgsWindow;
	import com.flaircode.util.FileUtils;
	import com.flaircode.util.FlaircodeUtils;
	import com.flaircode.util.LocaleUtil;
	import com.flaircode.util.SharedObjectBean;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Window;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.StringUtil;
	
	import org.swizframework.Swiz;

	public class LocaleController
	{
		
		private static const logger:ILogger = Log.getLogger("LocaleController");
		
		[Autowire]
		public var localeModel:LocaleModel;
		
		[Autowire]
		public var sourceModel:SourceModel;
		
		[Autowire]
		public var soBean:SharedObjectBean;
		
		public function LocaleController()
		{
		}
		
	
		[Mediate(event="DirtyEvent.DIRTY")]
		public function dirtyHandler():void
		{
			localeModel.dirty = true;
		}
		
		[Mediate(event="AppEvent.INIT")]
		public function initHandler():void
		{
			if(localeModel.localeDirPath != null)
			{
				var f:File = new File(localeModel.localeDirPath);
				if(f.exists)
				{
					initLocaleDir(f);
				}
				else
				{
					logger.warn("Latest localeDirPath does not exist anymore " + localeModel.localeDirPath);
					localeModel.localeDirPath = null;
				}
			}			
		}
		
		[Mediate(event="LocaleEvent.REFRESH")]
		public function refresh():void
		{
			initHandler();
		}
		
		[Mediate(event="LocaleEvent.CREATE", properties="locale")]
		public function createLocale(localeCode:String):void
		{
			var localeDir:LocaleDir = new LocaleDir();
			localeDir.locale = localeCode;
			localeDir.resourceBundles = new ArrayCollection();
			localeDir.path = localeModel.localeDirPath + "/" + localeCode;
			localeDir.selectedResourceBundle = localeModel.selectedResourceBundle;
			
			localeModel.localeDirs.addItem(localeDir);
			localeModel.locales.addItem(localeCode);
		}
		
		[Mediate(event="LocaleEvent.REMOVE", properties="locale")]
		public function removeLocale(locale:String):void
		{
			var ld:LocaleDir = localeModel.getLocaleDirByCode(locale);
			
			var msg:String = "Are you sure to delete {0} with all its contents?"
			msg = StringUtil.substitute(msg, ld.path);
			Alert.show(msg, "Delete Locale", Alert.OK | Alert.CANCEL, null, function(e:CloseEvent):void
			{
				if(e.detail == Alert.OK)
				{
					var index:int = localeModel.localeDirs.getItemIndex(ld);
					localeModel.localeDirs.removeItemAt(index);
					var f:File = new File(ld.path);
					if(f.exists && f.isDirectory)
					{
						f.deleteDirectory(true);
					}
					
					var localeIndex:int = localeModel.locales.getItemIndex(locale);
					localeModel.locales.removeItemAt(localeIndex);
				}
			});
			
		}
		
		[Mediate(event="LocaleEvent.BROWSE_LOCALE_DIR")]
		public function browseLocaleDirHandler():void
		{
			var f:File = new File();
			f.browseForDirectory("Select Locale Directory");
			f.addEventListener(Event.SELECT, onBrowseLocaleDir);
		}
		
		protected function onBrowseLocaleDir(e:Event):void
		{
			initLocaleDir(e.currentTarget as File);
		}
		
		protected function initLocaleDir(rootLocaleDir:File):void
		{
			// set path
			localeModel.localeDirPath = rootLocaleDir.nativePath;
			// set locales
			localeModel.locales = LocaleUtil.getLocalesFromDir(rootLocaleDir);
			// set resource bundles
			localeModel.resourceBundles = LocaleUtil.getResourceBundlesFromPath(rootLocaleDir, localeModel.locales);
			
			// set selectedResourceBundle
			if(localeModel.resourceBundles != null && localeModel.resourceBundles.length > 0)
			{
				localeModel.selectedResourceBundle = localeModel.resourceBundles.getItemAt(0) as String;
			}
			
			// set localeDirs
			var localeDirs:ArrayCollection = new ArrayCollection();
			for each(var locale:String in localeModel.locales)
			{
				var localeDir:File = rootLocaleDir.resolvePath(locale);
				if(!localeDir.exists)
				{
					throw new Error("Locale directory does not exist " + localeDir.nativePath);
				}
				else
				{
					var ld:LocaleDir = new LocaleDir();
					ld.locale = locale;
					ld.path = localeModel.localeDirPath + "/" + locale;
					ld.resourceBundles = LocaleUtil.getResourceBundlesForLocale(rootLocaleDir, locale);
					ld.selectedResourceBundle = localeModel.selectedResourceBundle;
					localeDirs.addItem(ld);
				}
			}
			
			localeModel.localeDirs = localeDirs;
			
			if(localeDirs.length > 0)
			{
				localeModel.selectedLocaleDir = localeDirs.getItemAt(0) as LocaleDir;
			}
		}
		
		[Mediate(event="LocaleEvent.SAVE_ALL")]
		public function saveAllHandler():void
		{
			logger.info("saveAll");
			
			for each(var ld:LocaleDir in localeModel.localeDirs)
			{
				if(ld.dirty)
				{
					saveLocale(ld);
				}
			}
			
			localeModel.dirty = false;
		}
		
		[Mediate(event="LocaleEvent.SYNC_FROM_SOURCE")]
		public function syncFromSource():void
		{
			if(localeModel.localeDirs != null && localeModel.localeDirs.length > 0)
			{
				for each(var ld:LocaleDir in localeModel.localeDirs)
				{
					ld.syncWithKeys(sourceModel.getKeys(sourceModel.sourceKey), localeModel.sourceSyncPrefix, localeModel.splitCamelCase);
				}
			}
			else
			{
				/* var localeDirRef:File = new File(localeModel.localeDirPath);
				var usFolder:File = localeDirRef.resolvePath("en_US")
				usFolder.createDirectory(); */
				
				var localeCode:String = "en_US";
				
				var keys:ArrayCollection = sourceModel.getKeys(sourceModel.sourceKey);
				var sourceKey:SourceKey = keys.getItemAt(0) as SourceKey;
				localeModel.locales.addItem("en_US");
				localeModel.resourceBundles = new ArrayCollection();
				localeModel.resourceBundles.addItem(sourceKey.resourceBundle);
				localeModel.selectedResourceBundle = sourceKey.resourceBundle;
				
				var localeDir:LocaleDir = new LocaleDir();
				localeDir.locale = localeCode;
				localeDir.resourceBundles = new ArrayCollection();
				localeDir.path = localeModel.localeDirPath + "/" + localeCode;
				localeDir.selectedResourceBundle = localeModel.selectedResourceBundle;
				
				localeModel.localeDirs.addItem(localeDir);
				
				localeDir.syncWithKeys(sourceModel.getKeys(sourceModel.sourceKey), localeModel.sourceSyncPrefix, localeModel.splitCamelCase);
			}
		}
		
		[Mediate(event="LocaleEvent.GENERATE_COMPILE_ARGS")]
		public function generate():void
		{
			var w:Window = new CompileArgsWindow();
			w.systemChrome = "none";
			w.transparent = true;
			w.type = NativeWindowType.LIGHTWEIGHT;
			Swiz.getInstance().registerWindow(w);
			w.open();
			FlaircodeUtils.centerToScreen(w);
		}
		
		[Mediate(event="LocaleEvent.PREVIEW_LOCALE")]
		public function previewLocale():void
		{
			logger.info("previewLocale");
			
			var slv:LocalePreviewView = new LocalePreviewView();
			Swiz.getInstance().registerWindow(slv);
			slv.width = 800;
			slv.height = 600;
			slv.open();
			FlaircodeUtils.centerToScreen(slv);
		}
		
		[Mediate(event="LocaleDirEvent.SAVE", properties="localeDir")]
		public function saveLocale(localeDir:LocaleDir):void
		{
			logger.debug("save " + localeDir.path);
			var res:String = localeDir.toString();
			var f:File = new File(localeDir.path + "/" + localeModel.selectedResourceBundle + ".properties");
			if(f.exists)
			{
				FileUtils.writeUTFBytes(f, res);
				localeDir.dirty = false;
			}
			else
			{
				// TODO handle file does not exist
			}
			
			var stillDirty:Boolean = false;
			for each(var ld:LocaleDir in localeModel.localeDirs)
			{
				if(ld.dirty)
				{
					stillDirty = true;
					break;
				}
			}
			
			localeModel.dirty = stillDirty;
		}
		
		[Mediate(event="LocaleEvent.CANCEL_LOCALE")]
		public function cancelHandler():void
		{
			var res:String = localeModel.selectedLocaleDir.toString();
			var filePath:String = localeModel.localeDirPath + "/"
			filePath +=  localeModel.selectedLocaleDir.locale + "/"
			filePath += localeModel.selectedResourceBundle + ".properties";
			var f:File = new File(filePath);
			if(f.exists)
			{
				// TODO implement cancel
			}
			else
			{
				// TODO handle file does not exist
			}
		}
		
		[Mediate(event="LocaleEvent.WRITE_LOCALE")]
		public function writeLocale():void
		{
			var res:String = localeModel.selectedLocaleDir.toString();
			var filePath:String = localeModel.localeDirPath + "/"
			filePath +=  localeModel.selectedLocaleDir.locale + "/"
			filePath += localeModel.selectedResourceBundle + ".properties";
			var f:File = new File(filePath);
			if(f.exists)
			{
				FileUtils.writeUTFBytes(f, res);
				localeModel.selectedLocaleDir.dirty = false;
			}
			else
			{
				// TODO handle file does not exist
			}
		}
		
		[Mediate(event="LocaleDirEvent.CHANGE", properties="localeDir")]
		public function changeLocaleDir(localeDir:LocaleDir):void
		{
			localeModel.selectedLocaleDir = localeDir;
		}
		
		[Mediate(event="ResourceSearchEvent.SEARCH", properties="searchQuery")]
		public function searchResource(searchQuery:String):void
		{
			localeModel.searchResource(searchQuery);
		}

	}
}