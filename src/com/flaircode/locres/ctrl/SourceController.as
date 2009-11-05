package com.flaircode.locres.ctrl {
	import com.flaircode.locres.domain.SourceFile;
	import com.flaircode.locres.domain.SourceKey;
	import com.flaircode.locres.event.TrackPageActionEvent;
	import com.flaircode.locres.model.SourceModel;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.swizframework.factory.IDispatcherBean;
	import org.swizframework.factory.IInitializingBean;
	import org.swizframework.storage.ISharedObjectBean;
	
	public class SourceController implements IInitializingBean, IDispatcherBean {
		
		private static const logger:ILogger = Log.getLogger( "SourceController" );
		
		[Autowire]
		public var model:SourceModel;
		
		[Autowire]
		public var so:ISharedObjectBean;
		
		private var _dispatcher:IEventDispatcher;
		
		public function set dispatcher( dispatcher : IEventDispatcher ) : void {
			_dispatcher = dispatcher;
		}
		
		public function SourceController() {
		}
		
		[Mediate(event="SourceEvent.REFRESH")]
		public function refresh() : void {
			_dispatcher.dispatchEvent( new TrackPageActionEvent( TrackPageActionEvent.ACTION, "SOURCE", "refresh", "-" ) );
			initialize();
		}
		
		public function initialize() : void {
			model.sourceKey = so.getString( "sourceKey", "$Key" );
			
			var path:String = so.getString( "sourceDir" );
			if ( path != null ) {
				var f:File = new File( path );
				if ( f.exists && f.isDirectory ) {
					initSourceDir( f );
				}
			}
		}
		
		[Mediate(event="SourceEvent.BROWSE_DIR")]
		public function browseDirHandler() : void {
			_dispatcher.dispatchEvent( new TrackPageActionEvent( TrackPageActionEvent.ACTION, "SOURCE", "browse", "-" ) );
			
			var f:File = new File();
			f.browseForDirectory( "Select Source Directory" );
			f.addEventListener( Event.SELECT, dirSelectHandler );
		}
		
		protected function dirSelectHandler( e : Event ) : void {
			var f:File = e.currentTarget as File;
			initSourceDir( f );
		}
		
		protected function initSourceDir( dir : File ) : void {
			parseSourceDir( dir );
			model.sourceDir = dir;
			so.setString( "sourceDir", dir.nativePath );
			
			model.keys = getKeys( model.sourceKey );
		}
		
		[Mediate(event="SourceEvent.KEY_CHANGE")]
		public function keyChange() : void {
			so.setString( "sourceKey", model.sourceKey );
			model.keys = getKeys( model.sourceKey );
		}
		
		protected function getKeys( key : String ) : ArrayCollection {
			var res:Array = new Array();
			for each ( var sf : SourceFile in model.sourceFiles ) {
				var a:Array = sf.getByKey( key )
				res = res.concat( a );
			}
			
			var dict:Dictionary = new Dictionary();
			var uniqueRes:Array = [];
			for each ( var sk : SourceKey in res ) {
				if ( dict[sk.key] == null ) {
					dict[sk.key] = {};
					uniqueRes.push( sk );
				}
			}
			
			return new ArrayCollection( uniqueRes );
		}
		
		protected function parseSourceDir( dir : File ) : void {
			var files:Array = getFilesFromDir( dir, [ "as", "mxml", "java" ] );
			logger.info( "source files " + files.length );
			
			var loc:uint = 0;
			var sourceFiles:Array = new Array();
			for each ( var f : File in files ) {
				var sf:SourceFile = new SourceFile( f );
				var pack:String = f.nativePath.substring( dir.nativePath.length + 1, f.nativePath.lastIndexOf( "/" ) );
				pack = pack.replace( /\//g, "." );
				if ( pack.length <= 1 ) {
					pack = "";
				}
				sf.pack = pack;
				sourceFiles.push( sf );
				loc += sf.loc;
			}
			
			model.sourceFiles = new ArrayCollection( sourceFiles );
			model.loc = loc;
		}
		
		/**
		 * Recursive get files from directory
		 *
		 * @param dir Directory File
		 * @param extensions Array of file extensions like ["as","mxml"]
		 * @return Array of files
		 *
		 */
		public function getFilesFromDir( dir : File, extensions : Array = null ) : Array {
			var res:Array = new Array();
			var listing:Array = dir.getDirectoryListing();
			for each ( var f : File in listing ) {
				if ( !f.isDirectory ) {
					if ( extensions == null ) {
						res.push( f );
					} else {
						for each ( var ext : String in extensions ) {
							if ( ext == f.extension ) {
								res.push( f );
								break;
							}
						}
					}
				} else {
					res = res.concat( getFilesFromDir( f, extensions ) );
				}
			}
			return res;
		}
	
	}
}