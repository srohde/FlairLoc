package com.flaircode.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class FileUtils
	{
		private static const logger:ILogger = Log.getLogger("FileUtils");
		
		public static function readFile(file:File):String
        {
            if(file.exists)
            {
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.READ);
                var str:String =  fs.readUTFBytes(fs.bytesAvailable);
                fs.close();
                return str;
            }
            throw new Error("FileUtil.readFile " + file.nativePath + " does not exist");
        }
        
        public static function writeUTFBytes(file:File, str:String):void
        {
            var fs:FileStream = new FileStream();
            try
            {
                fs.open(file, FileMode.WRITE);
                fs.writeUTFBytes(str);
                fs.close();
            }
            catch(e:Error)
            {
                logger.error("could not write " + file.nativePath);
            }
        }

	}
}