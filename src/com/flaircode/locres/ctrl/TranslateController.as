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
package com.flaircode.locres.ctrl {
	import com.flaircode.locres.domain.LocaleDir;
	import com.flaircode.locres.domain.Resource;
	import com.flaircode.locres.event.FooterEvent;
	import com.flaircode.locres.model.LocaleModel;
	import com.soenkerohde.ga.event.TrackActionEvent;
	
	import flash.events.IEventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import org.flaircode.locale.LocaleAPI;
	import org.swizframework.Swiz;
	import org.swizframework.controller.AbstractController;
	import org.swizframework.factory.IDispatcherBean;
	
	public class TranslateController extends AbstractController implements IDispatcherBean {
		
		private static const logger:ILogger = Log.getLogger( "TranslateCtrl" );
		
		[Autowire]
		public var api:LocaleAPI;
		
		[Autowire]
		public var localeModel:LocaleModel;
		
		private var translateToken:AsyncToken;
		
		private var _dispatcher:IEventDispatcher;
		
		public function set dispatcher( dispatcher : IEventDispatcher ) : void {
			_dispatcher = dispatcher;
		}
		
		public function TranslateController() {
		}
		
		[Mediate(event="TranslateResourceEvent.TRANSLATE", properties="resource,fromLang,toLang")]
		public function translateResource( resource : Resource, fromLang : String, toLang : String ) : void {
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "RESOURCE", "translate", fromLang + "->" + toLang ) );
			
			var fromLocaleDir:LocaleDir = localeModel.getLocaleDirByCode( fromLang );
			var fromResource:Resource = fromLocaleDir.getResourceByKey( resource.name );
			if ( fromResource != null ) {
				
				// FIXME fromLang zh_TW should be lang+country
				
				CursorManager.setBusyCursor();
				var query:String = fromResource.value;
				if ( toLang.indexOf( "zh" ) == -1 ) {
					toLang = toLang.substr( 0, 2 );
				} else {
					toLang = toLang.replace( "_", "-" );
				}
				logger.info( "translate " + query + " from " + fromLang + " to " + toLang );
				var token:AsyncToken = api.localize( query, fromLang, toLang );
				executeServiceCall( token, translateResourceResult, null, [ resource ] );
			} else {
				// TODO handle resource not available
			}
		}
		
		protected function translateResourceResult( re : ResultEvent, resource : Resource ) : void {
			CursorManager.removeBusyCursor();
			logger.info( "translateResourceResult " + re.result );
			resource.value = re.result as String;
		}
		
		[Mediate(event="TranslateEvent.TRANSLATE", properties="localeDir,fromLang")]
		public function translate( localeDir : LocaleDir, fromLang : String ) : void {
			
			var fromLocaleDir:LocaleDir = localeModel.getLocaleDirByCode( fromLang );
			var queries:Array = new Array();
			
			var toLang:String = localeDir.locale;
			if ( toLang.indexOf( "zh" ) == -1 ) {
				toLang = toLang.substr( 0, 2 );
			} else {
				toLang = toLang.replace( "_", "-" );
			}
			
			_dispatcher.dispatchEvent( new TrackActionEvent( TrackActionEvent.ACTION, "RESOURCE", "translate all", fromLang + "->" + toLang ) );
			
			// FIXME fromLang zh_TW should be lang+country
			
			for each ( var rb : Resource in fromLocaleDir.resources ) {
				if ( rb.value.indexOf( "$" ) != 0 ) {
					var trans:Object = {query: rb.value, key: rb.name, fromLang: fromLang, toLang: toLang};
					queries.push( trans );
				}
			}
			
			exec( queries, localeDir );
		}
		
		private function exec( queries : Array, localeDir : LocaleDir ) : void {
			var locThis:Object = queries.shift();
			logger.info( "translate " + locThis.query + " from " + locThis.fromLang + " to " + locThis.toLang );
			var msg:String = "translate " + locThis.query + " from " + locThis.fromLang + " to " + locThis.toLang;
			Swiz.dispatchEvent( new FooterEvent( FooterEvent.STATUS, msg, true ) );
			translateToken = api.localize( locThis.query, locThis.fromLang, locThis.toLang );
			executeServiceCall( translateToken, result, null, [ queries, localeDir, locThis.key ] );
		}
		
		public function result( re : ResultEvent, queries : Array, localeDir : LocaleDir, key : String ) : void {
			logger.info( "result " + key + "=" + re.result.toString() );
			
			//Swiz.dispatchEvent(new FooterEvent(FooterEvent.STATUS, ""));
			
			var found:Boolean = false;
			for each ( var resource : Resource in localeDir.resources ) {
				if ( resource.name == key ) {
					resource.value = re.result as String;
					found = true;
				}
			}
			
			if ( !found ) {
				var res:Resource = new Resource();
				res.name = key;
				res.value = re.result as String;
				res.comment = "";
				localeDir.resources.addItem( res );
			}
			
			localeDir.dirty ||= true;
			
			if ( queries.length > 0 ) {
				exec( queries, localeDir );
			}
		}
	
	}
}