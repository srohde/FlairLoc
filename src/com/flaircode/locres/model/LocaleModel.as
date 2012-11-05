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
package com.flaircode.locres.model {
	import com.flaircode.locres.dao.ILocalesDAO;
	import com.flaircode.locres.domain.LocaleDir;
	import com.flaircode.locres.domain.Resource;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.swizframework.storage.ISharedObjectBean;
	
	
	public class LocaleModel extends EventDispatcher {
		private static const logger:ILogger = Log.getLogger( "LocaleModel" );
		
		
		[Bindable]
		public function get sourceSyncPrefix() : String {
			return soBean.getValue( "sourceSyncPrefix", "" );
		}
		
		public function set sourceSyncPrefix( prefix : String ) : void {
			soBean.setValue( "sourceSyncPrefix", prefix );
		}
		
		[Bindable]
		public function get splitCamelCase() : Boolean {
			return soBean.getValue( "splitCamelCase", true );
		}
		
		public function set splitCamelCase( split : Boolean ) : void {
			soBean.setValue( "splitCamelCase", split );
		}
		
		[Bindable]
		public function get compileArgs() : String {
			var s:String = "-source-path+=../locale/{locale} -locale";
			for each ( var locale : String in locales ) {
				s += " " + locale;
			}
			return s;
		}
		
		[Bindable]
		public function get compileArgsAnt() : String {
			var s:String = 'locale="';
			for each ( var locale : String in locales ) {
				s += locale + ",";
			}
			// kill last comma
			s = s.substr( 0, s.length - 1 );
			s += '"';
			return s;
		}
		
		[Bindable]
		public function get compileArgsAntSourcePath() : String {
			return '<source-path path-element="${basedir}/locale/{locale}" />';
		}
		
		[Autowire]
		public var soBean:ISharedObjectBean;
		
		[Autowire]
		public var localeDAO:ILocalesDAO;
		
		// use to save search string before setting filter function
		private var searchQuery:String;
		
		[Bindable]
		public var localeDirs:ArrayCollection;
		
		[Bindable]
		public var localeDir:File;
		
		[Bindable]
		public var dirty:Boolean = false;
		
		// collection of locale codes
		[Bindable]
		public var locales:ArrayCollection = new ArrayCollection();
		
		// collection of String
		[Bindable]
		public var resourceBundles:ArrayCollection;
		
		// UI Related ############################################################
		
		private var _selectedResourceBundle:String;
		
		[Bindable]
		public function get selectedResourceBundle() : String {
			return _selectedResourceBundle;
		}
		
		public function set selectedResourceBundle( rb : String ) : void {
			_selectedResourceBundle = rb;
			selectedResourceBundleIndex = resourceBundles.getItemIndex( rb );
		}
		
		[Bindable]
		public var selectedResourceBundleIndex:int;
		
		[Bindable]
		public var selectedLocaleDir:LocaleDir;
		
		public function LocaleModel() {
		}
		
		public function getLocaleDirByCode( code : String ) : LocaleDir {
			for each ( var ld : LocaleDir in localeDirs )
				if ( ld.locale == code )
					return ld;
			return null;
		}
		
		public function searchResource( searchQuery : String ) : void {
			this.searchQuery = searchQuery;
			selectedLocaleDir.resources.filterFunction = searchQuery == "" ? null : filterResource;
			selectedLocaleDir.resources.refresh();
		}
		
		protected function filterResource( resource : Resource ) : Boolean {
			searchQuery = searchQuery.toLowerCase();
			var b:Boolean = resource.name.toLowerCase().indexOf( searchQuery ) != -1;
			b = b || resource.value.toLowerCase().indexOf( searchQuery ) != -1;
			return b;
		}
	
	}
}