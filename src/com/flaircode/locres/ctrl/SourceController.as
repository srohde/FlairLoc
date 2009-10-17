package com.flaircode.locres.ctrl {
	import com.flaircode.locres.domain.SourceFile;
	import com.flaircode.locres.model.SourceModel;
	import com.flaircode.locres.view.source.CompileArgsWindow;
	import com.flaircode.util.FlaircodeUtils;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.core.Window;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.swizframework.Swiz;
	
	public class SourceController {
		private static const logger:ILogger = Log.getLogger( "SourceController" );
		
		[Autowire]
		public var sourceModel:SourceModel;
		
		public function SourceController() {
		}
		
		[Mediate(event="AppEvent.INIT")]
		public function initHandler() : void {
			if ( sourceModel.sourceDir != null ) {
				if ( sourceModel.sourceDir.exists ) {
					parseSourceDir( sourceModel.sourceDir );
					sourceModel.handleFilesChange();
				} else {
					logger.warn( "Latest sourcePath does not exist anymore " + sourceModel.sourceDir.nativePath );
					sourceModel.sourceDir = null;
				}
			}
		}
		
		[Mediate(event="SourceEvent.REFRESH")]
		public function refresh() : void {
			initHandler();
		}
		
		[Mediate(event="SourceEvent.BROWSE_DIR")]
		public function browseDirHandler() : void {
			var f:File = new File();
			f.browseForDirectory( "Select Source Directory" );
			f.addEventListener( Event.SELECT, dirSelectHandler );
		}
		
		protected function dirSelectHandler( e : Event ) : void {
			var f:File = e.currentTarget as File;
			parseSourceDir( f );
			sourceModel.sourceDir = f;
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
			
			sourceModel.sourceFiles = new ArrayCollection( sourceFiles );
			sourceModel.loc = loc;
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