package com.flaircode.locres.dao
{
	import com.flaircode.locres.domain.Locale;
	import com.flaircode.util.FileUtils;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	public class LocaleDAO implements ILocalesDAO
	{
		public function LocaleDAO()
		{
		}

		public function getLocales():ArrayCollection
		{
			var f:File = File.applicationDirectory.resolvePath("locales.xml");
			var s:String = FileUtils.readFile(f);
			var x:XML = new XML(s);
			var locales:Array = new Array();
			for each(var l:XML in x.locale)
			{
				var locale:Locale = new Locale(l.@code, l.@name);
				locales.push(locale);
			}
			return new ArrayCollection(locales);
		}
		
	}
}