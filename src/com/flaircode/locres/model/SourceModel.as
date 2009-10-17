package com.flaircode.locres.model
{
	import com.flaircode.locres.domain.SourceFile;
	import com.flaircode.locres.domain.SourceKey;
	import com.flaircode.util.SharedObjectBean;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class SourceModel extends EventDispatcher
	{
		
		private static const logger:ILogger = Log.getLogger("SourceModel");
		
		[Autowire]
		public var soBean:SharedObjectBean;
		
		private var _sourceKey:String;
		
		[Bindable]
		public function get sourceKey():String
		{
			return soBean.getValue("sourceKey", "$Key");
		}
		public function set sourceKey(key:String):void
		{
			soBean.setValue("sourceKey", key);
			handleFilesChange();
		}
		
		// collection of SourceFile
		[Bindable]
		public var sourceFiles:ArrayCollection;
		
		[Bindable]
		public var loc:uint = 0;
		
		private var _sourceDir:File;
		
		[Bindable]
		public var keys:ArrayCollection;
		
		[Bindable]
		public function get sourceDir():File
		{
			if(_sourceDir == null)
			{
				var path:String = soBean.getValue("sourceDir");
				if(path != null)
				{
					_sourceDir = new File(path);
				}
			}
			return _sourceDir;
		}
		
		public function set sourceDir(dir:File):void
		{
			_sourceDir = null;
			soBean.setValue("sourceDir", dir.nativePath);
			handleFilesChange();
		}
		
		public function SourceModel()
		{
			sourceFiles = new ArrayCollection();
		}
		
		public function handleFilesChange():void
		{
			keys = null;
			dispatchEvent(new Event("sourceDirChange"));
		}
		
		[Bindable(event="sourceDirChange")]
		public function getKeys(key:String):ArrayCollection
		{
			if(key == "")
			{
				return new ArrayCollection();
			}
			if(keys == null)
			{
				var res:Array = new Array();
				for each(var sf:SourceFile in sourceFiles)
				{
					res = res.concat(sf.getByKey(key));
				}
				
				var dict:Dictionary = new Dictionary();
				var uniqueRes:Array = [];
				for each(var sk:SourceKey in res)
				{
					if(dict[sk.key] == null)
					{
						dict[sk.key] = {};
						uniqueRes.push(sk);
					}
				}
				
				keys = new ArrayCollection(uniqueRes)
			}
			return keys;
		}

	}
}