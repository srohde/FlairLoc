/*
Copyright 2009 Sönke Rohde

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
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