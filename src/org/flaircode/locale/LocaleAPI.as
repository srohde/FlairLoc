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
package org.flaircode.locale
{
	import com.adobe.serialization.json.JSON;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class LocaleAPI
	{
		private static const logger:ILogger = Log.getLogger("LocaleAPI");
		
		private var _service:HTTPService;
		
		private var localizeToken:AsyncToken;
		
		public function get service():HTTPService
		{
			if(_service == null)
			{
				_service = new HTTPService();
				_service.url = "http://ajax.googleapis.com/ajax/services/language/translate";
				service.request.v = '1.0';
                service.resultFormat = 'text';
			}
			return _service;
		}
		
		public function LocaleAPI()
		{
		}
		
		public function localize(query:String, fromLang:String, toLang:String):AsyncToken
		{
			logger.info("locallize " + query + " from " + fromLang + " to " + toLang);
			service.request.q = query;
            service.request.langpair = fromLang + "|" + toLang;
            
			service.addEventListener(ResultEvent.RESULT, result);
			service.send();
            
            localizeToken = new AsyncToken(null);
            return localizeToken;
		}
		
		private function result(re:ResultEvent):void
		{
			var result:String = re.result as String;
			logger.info("result " + result);
			
			try
			{
				var feed:Object = JSON.decode(result);
				//trace(feed.responseData.translatedText);
				
				for each(var responder:IResponder in localizeToken.responders)
				{
					var data:Object = new ResultEvent(ResultEvent.RESULT, false, true, feed.responseData.translatedText);
					responder.result(data);
				}
				
				/* for web search results
				for(var p:String in feed.responseData.results){
				trace(feed.responseData.results[p].titleNoFormatting);
				trace(feed.responseData.results[p].url);
				trace(feed.responseData.results[p].content);
				trace(feed.responseData.results[p].title);
				} */
			} 
			catch(e:Error)
			{
				logger.error(e.message);
			}
		}

	}
}