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