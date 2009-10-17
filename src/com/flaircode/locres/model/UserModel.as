package com.flaircode.locres.model
{
	import com.flaircode.util.SharedObjectBean;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	public class UserModel
	{
		
		public static const KIND_DEVELOPER:String = "kindDeveloper";
		public static const KIND_TRANSLATOR:String = "kindTranslator";
		
		[Autowire]
		public var soBean:SharedObjectBean;
		
		private var _flexSDKPath:String;
		
		[Bindable]
		public var sdkLocales:ArrayCollection;
		
		public function UserModel()
		{
		}
		
		[Bindable]
		public function get flexSDKPath():String
		{
			if(_flexSDKPath == null)
			{
				var path:String = soBean.getValue("flexSDKPath");
				if(path != null)
				{
					var f:File = new File(path);
					if(f.exists && f.isDirectory)
					{
						_flexSDKPath = path;
						initFlexSDKLocales();
					}
				}
			}
			return _flexSDKPath;
		}
		
		public function set flexSDKPath(path:String):void
		{
			var localeDir:File = new File(path + "/frameworks/locale");
			if(localeDir.exists)
			{
				_flexSDKPath = path;
				soBean.setValue("flexSDKPath", path);
				initFlexSDKLocales();
			}
			else
			{
				throw new Error(path + " is not Flex SDK directory.");
			}
		}
		
		public function reset():void
		{
			soBean.reset();
		}
		
		protected function initFlexSDKLocales():void
		{
			var localeDir:File = new File(flexSDKPath + "/frameworks/locale");
			var localeDirs:Array = localeDir.getDirectoryListing();
			var locales:Array = new Array();
			for each(var f:File in localeDirs)
			{
				// locale dirs have an underscore an the third position by definition
				if(f.name.indexOf("_") == 2)
				{
					locales.push(f.name);
				}
			}
			sdkLocales = new ArrayCollection(locales);
		}

	}
}