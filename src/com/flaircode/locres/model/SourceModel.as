package com.flaircode.locres.model {
	import com.flaircode.locres.domain.SourceFile;
	import com.flaircode.locres.domain.SourceKey;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class SourceModel extends EventDispatcher {
		
		private static const logger:ILogger = Log.getLogger( "SourceModel" );
		
		[Bindable]
		public var sourceKey:String;
		
		// collection of SourceFile
		[Bindable]
		public var sourceFiles:ArrayCollection;
		
		[Bindable]
		public var loc:uint = 0;
		
		private var _sourceDir:File;
		
		[Bindable]
		public var keys:ArrayCollection;
		
		[Bindable]
		public var sourceDir : File;
		
		public function SourceModel() {
			sourceFiles = new ArrayCollection();
		}
	
	
	
	}
}