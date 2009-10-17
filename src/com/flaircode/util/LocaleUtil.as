package com.flaircode.util
{
	import com.adobe.utils.ArrayUtil;
	import com.flaircode.locres.domain.Resource;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class LocaleUtil
	{
		private static const logger:ILogger = Log.getLogger("LocaleUtil");
		
		public static function getLocalesFromDir(dir:File):ArrayCollection
		{
			// the result
			var result:ArrayCollection = new ArrayCollection();
			
			// locale directories
			var a:Array = dir.getDirectoryListing();
			for each(var dir:File in a)
			{
				if(dir.name.charAt(2) == "_" || dir.name.length == 2)
				{
					logger.debug("processsing localeDir " + dir.name);
					result.addItem(dir.name);
				}
			}
			return result;
		}
		
		public static function getResourceBundlesForLocale(rootLocaleDir:File, locale:String):ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection();
			if(rootLocaleDir != null && rootLocaleDir.exists && rootLocaleDir.isDirectory)
			{
				var localeDir:File = rootLocaleDir.resolvePath(locale);
				if(localeDir.exists && localeDir.isDirectory)
				{
					var resourceBundleFiles:Array = localeDir.getDirectoryListing();
					for each(var rbFile:File in resourceBundleFiles)
					{
						if(rbFile.name.indexOf(".properties") != -1)
						{
							var rbName:String = rbFile.name.substr(0, rbFile.name.indexOf("."));
							logger.debug("processsing resourceBundle " + rbName);
							result.addItem(rbName);
						}
					}
				}
			}
			return result;
		}
		
		public static function getResourceBundlesFromPath(rootLocaleDir:File, locales:ArrayCollection):ArrayCollection
		{
			var result:Array = new Array();
			
			if(rootLocaleDir != null && rootLocaleDir.exists && rootLocaleDir.isDirectory)
			{
				var resourceBundles:ArrayCollection = new ArrayCollection();
				for each(var locale:String in locales)
				{
					// TODO use getResourceBundlesForLocale
					var rbs:ArrayCollection = getResourceBundlesForLocale(rootLocaleDir, locale);
					result = result.concat(rbs.toArray());
				}
			}
			else
			{
				throw new Error("rootLocaleDir invalid " + rootLocaleDir);
			}
			result = ArrayUtil.createUniqueCopy(result)
			return new ArrayCollection(result);
		}
		
		
		/**
		 * convert locale file to Resource collection
		 *  
		 * @param s
		 * @return Collection of Resource
		 * 
		 */		
		public static function string2resources(s:String):ArrayCollection
		{
			var res:Array = new Array();
			var a:Array = s.split("\n");
			var len:uint = a.length;
			for(var i:uint = 0; i < len; i++)
			{
				var nv:String = a[i];
				if(nv.charAt(0) != "#" && nv.length > 0)
				{
					//logger.debug("process " + nv);
					var rblocale:Resource = new Resource();
					rblocale.name = nv.substr(0, nv.indexOf("="));
					rblocale.value = nv.substr(nv.indexOf("=") + 1, nv.length);
					
					var comment:String = "";
					var j:uint = i;
					while(--j > 0)
					{
						var c:String = a[j];
						if(c.charAt(0) == "#")
						{
							if(comment == "")
							{
								comment = comment + c + "\n";
							}
							else
							{
								comment = c + "\n" + comment;
							}
						}
						else if(c != "")
						{
							j = 0;
						}
					}
					
					rblocale.comment = comment;
					
					while(LocaleUtil.hasNextLine(nv))
					{
						rblocale.isMultiline = true;
						
						if(i < a.length - 1)
						{
							rblocale.value += "\n";
							var nextLine:String = a[i + 1];
							rblocale.value += nextLine;
							i += 1;
							nv = nextLine;
						}
						else
						{
							break;
						}
					}
					res.push(rblocale);
				}
			}
			return new ArrayCollection(res);
		}
		
		
		/**
		 * convert resources to the string representation
		 *  
		 * @param ac
		 * @return 
		 * 
		 */		
		public static function resources2string(ac:ArrayCollection):String
		{
			var oldFilterFunction:Function = ac.filterFunction;
			ac.filterFunction = null;
			ac.refresh();
			
			var res:String = "";
			for each(var item:Resource in ac)
			{
				if(item.comment != "")
				{
					res += item.comment;
				}
				res += item.name + "=" + item.value;
				res += "\n";
			}
			
			if(oldFilterFunction != null)
			{
				ac.filterFunction = oldFilterFunction;
				ac.refresh();
			}
			
			return res;
		}
		
		/**
		 * 
		 * @param line String
		 * @return Boolean if line has next line
		 * 
		 */		
		private static function hasNextLine(line:String):Boolean
		{
			// TODO trim string so that the blackslash is really the last
			if(line.charAt(line.length - 1) == "\\")
			{
				return true;
			}
			return false;
		}

	}
}