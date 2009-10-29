package com.flaircode.locres.domain {
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class SourceFile {
		
		private static const logger:ILogger = Log.getLogger( "SourceFile" );
		
		public var file:File;
		
		public var name:String;
		public var pack:String;
		
		private var _content:String;
		private var _loc:int = -1;
		private var _mediates:int = -1;
		private var _autowire:int = -1;
		private var _locales:int = -1;
		private var _localeKeys:Array;
		
		public function get loc() : int {
			if ( _loc == -1 ) {
				_loc = content.split( "\n" ).length;
			}
			return _loc;
		}
		
		public function get content() : String {
			if ( _content == null ) {
				var fs:FileStream = new FileStream();
				fs.open( file, FileMode.READ );
				_content =  fs.readUTFBytes( fs.bytesAvailable );
				fs.close();
			}
			return _content;
		}
		
		public function get mediates() : int {
			if ( _mediates == -1 ) {
				var re:RegExp = /\bMediate.*/gi;
				var a:Array = content.match( re );
				_mediates = a.length;
			}
			return _mediates;
		}
		
		public function get autowires() : int {
			if ( _autowire == -1 ) {
				_autowire = content.match( /\bAutowire.*/gi ).length;
			}
			return _autowire;
		}
		
		public function get locales() : int {
			if ( _locales == -1 ) {
				var count:int = 0;
				count += content.match( /\b@Resource.*/gi ).length;
				count += content.match( /\bresourceManager.*/gi ).length;
				_locales = count
			}
			return _locales;
		}
		
		public function SourceFile( file : File ) {
			this.file = file;
			name = file.name;
		}
		
		public function getByKey( sourceKey : String ) : Array {
			_localeKeys = new Array();
			
			var dict:Dictionary = new Dictionary();
			
			var index:int = 0;
			while ( index != -1 ) {
				index = content.indexOf( sourceKey, index );
				
				if ( index != -1 ) {
					var key:String = getResourceKeyByIndex( content, index );
					var previousQuoteIndex:int = Math.max( content.lastIndexOf( '"', index - 2 ), content.lastIndexOf( "'", index - 2 ) );
					var openingQuoteIndex:int = Math.max( content.lastIndexOf( '"', previousQuoteIndex - 1 ), content.lastIndexOf( "'", previousQuoteIndex - 1 ) );
					var rb:String = content.substring( openingQuoteIndex + 1, previousQuoteIndex );
					
					
					if ( dict[rb + "_" + key] == null ) {
						var sk:SourceKey = new SourceKey();
						sk.key = key;
						sk.resourceBundle = rb;
						sk.count = 1;
						_localeKeys.push( sk )
						dict[rb + "_" + key] = sk;
					} else {
						var tempSK:SourceKey = dict[rb + "_" + key];
						tempSK.count += 1;
					}
					
					index = index + 1;
				}
			}
			
			return _localeKeys;
		}
		
		/**
		 *
		 * @param content source code
		 * @param index of the found key prefix
		 * @return key name
		 *
		 */
		private function getResourceKeyByIndex( content : String, index : int ) : String {
			// get pos of next ")" or "}"
			logger.info( "getResourceKeyByIndex " + content.substring( index, index + 75 ) );
			
			var nextClosingBracket:int = content.indexOf( ")", index );
			var nextCurvedBracket:int = content.indexOf( "}", index );
			var endPos:int;
			if ( nextClosingBracket == -1 && nextCurvedBracket == -1 ) {
				throw new Error( "unabled to dermine ending of resource key: " + content.substr( index, 20 ) );
			}
			if ( nextClosingBracket == -1 ) {
				endPos = nextCurvedBracket;
			} else if ( nextCurvedBracket == -1 ) {
				endPos = nextClosingBracket;
			} else {
				endPos = Math.min( nextClosingBracket, nextCurvedBracket )
			}
			
			
			// get pos of next ","
			var commaPos:int = content.indexOf( ",", index );
			
			// take the min pos of both above
			if ( commaPos != -1 && commaPos < endPos ) {
				endPos = commaPos;
			}
			
			// get intermediate string
			content = content.substring( index, endPos );
			// remove spaces
			content = content.replace( " ", "" );
			
			// get the key with the given indices
			var key:String = content.substring( 0, content.length - 1 );
			logger.info( "key " + key );
			return key;
		}
	
	}
}