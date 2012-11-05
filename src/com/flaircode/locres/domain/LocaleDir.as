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
package com.flaircode.locres.domain {
	import com.flaircode.locres.event.DirtyEvent;
	import com.flaircode.util.FileUtils;
	import com.flaircode.util.LocaleUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.swizframework.Swiz;
	
	[Event("change")]
	
	[Bindable]
	public class LocaleDir extends EventDispatcher {
		private static const logger:ILogger = Log.getLogger( "LocaleDir" );
		
		public var path:String;
		public var locale:String;
		public var resourceBundles:ArrayCollection;
		
		private var list:ArrayCollection;
		
		[Bindable(event="resourcesChange")]
		public var resources:ListCollectionView;
		
		[Bindable(event="resourcesChange")]
		public function get keyCount() : int {
			return list.length;
		}
		
		private var _selectedResourceBundle:String;
		
		// true if a resource changed
		private var _dirty:Boolean = false;
		
		public function get dirty() : Boolean {
			return _dirty;
		}
		
		public function set dirty( b : Boolean ) : void {
			_dirty = b;
			Swiz.dispatchEvent( new DirtyEvent( DirtyEvent.DIRTY ) );
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
		public function set selectedResourceBundle( rb : String ) : void {
			_selectedResourceBundle = rb;
			if ( rb != null ) {
				var localeResourceBundle:File = new File( path ).resolvePath( rb + ".properties" );
				if ( localeResourceBundle.exists ) {
					var resourceBundleContent:String = FileUtils.readFile( localeResourceBundle );
					list = LocaleUtil.string2resources( resourceBundleContent );
				} else {
					resourceBundles.addItem( rb );
					var fileStream:FileStream = new FileStream();
					fileStream.open( localeResourceBundle, FileMode.WRITE );
					fileStream.writeUTFBytes( "" );
					fileStream.close();
					list = new ArrayCollection();
				}
				createResources( list );
				
				dispatchEvent( new Event( "resourcesChange" ) );
			}
		}
		
		public function get selectedResourceBundle() : String {
			return _selectedResourceBundle;
		}
		
		public function LocaleDir() {
		}
		
		public function getResourceByKey( key : String ) : Resource {
			for each ( var resource : Resource in resources ) {
				if ( resource.name == key )
					return resource;
			}
			return null;
		}
		
		protected function createResources( list : ArrayCollection ) : void {
			var sort:Sort = new Sort();
			sort.fields = [new SortField( "name" )];
			list.sort = sort;
			list.refresh();
			resources = new ListCollectionView( list );
			resources.removeEventListener( CollectionEvent.COLLECTION_CHANGE, onCollectionChange );
			resources.addEventListener( CollectionEvent.COLLECTION_CHANGE, onCollectionChange, false, 0, true );
		}
		
		public function syncWithKeys( keys : ArrayCollection, prefix : String, splitCamelCase : Boolean ) : void {
			if ( resources == null ) {
				createResources( new ArrayCollection() );
			}
			logger.debug( "syncWithKeys " + keys.length );
			
			var changed:Boolean = false;
			var result:Array = new Array();
			for each ( var sk : SourceKey in keys ) {
				var key:String = sk.key;
				
				var hasKey:Boolean = false;
				var cursor:IViewCursor = resources.createCursor();
				while ( !cursor.afterLast ) {
					var res:Resource = cursor.current as Resource;
					
					//logger.debug(locale + " check " + res.name);
					//hasKey = false;
					
					if ( res.name == key && !hasKey ) {
						hasKey = true;
						// if autofill
						if ( res.value == null || res.value == "" ) {
							var val:String = prefix + key.substr( key.lastIndexOf( "/" ) + 1 );
							var resVal:String = "";
							if ( splitCamelCase ) {
								for ( var i:int = 0; i < val.length; i++ ) {
									var cCode:Number = val.charCodeAt( i );
									if ( cCode >= 65 && cCode <= 90 && i > 0 ) {
										resVal += " ";
									}
									resVal += val.charAt( i );
								}
							}
							res.value = val;
							
						}
						result.push( res );
						//logger.debug(locale + "hasKey " + key);
						break;
					}
					cursor.moveNext();
				}
				
				if ( !hasKey ) {
					changed = true;
					//logger.error(locale + " !hasKey " + key);
					var resource:Resource = new Resource();
					resource.name = key;
					resource.value = prefix + key.substr( key.lastIndexOf( "/" ) + 1 );
					
					var resNewVal:String = "";
					if ( splitCamelCase ) {
						for ( var j:int = 0; j < resource.value.length; j++ ) {
							var ccCode:Number = resource.value.charCodeAt( j );
							if ( ccCode >= 65 && ccCode <= 90 && j > 0 ) {
								resNewVal += " ";
							}
							resNewVal += resource.value.charAt( j );
						}
					}
					resource.value = resNewVal;
					
					resource.comment = "";
					result.push( resource );
				}
				
				
			}
			
			/* if(keys.length != result.length)
			   {
			   changed = true;
			   result = ArrayUtil.createUniqueCopy(result);
			 } */
			
			changed = changed || list.length != result.length;
			if ( changed ) {
				list = new ArrayCollection( result );
				createResources( list );
				dirty = true;
			}
		}
		
		private function onCollectionChange( e : CollectionEvent ) : void {
			if ( e.kind == CollectionEventKind.UPDATE ) {
				dirty = true;
			}
		}
		
		override public function toString() : String {
			return LocaleUtil.resources2string( list );
		}
	
	
	}
}