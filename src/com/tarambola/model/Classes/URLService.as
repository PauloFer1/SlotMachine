package com.tarambola.model.Classes
{
	import com.tarambola.controller.NavEvents;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class URLService
	{
		
		private var _url:String = "";
		private var _request:URLRequest;
		private var _urlLoader:URLLoader;
		
		public function URLService()
		{
			this._request = new URLRequest(_url);
			this._request.method = URLRequestMethod.POST;
		}
		public function getUniqueId():void
		{
			this._url = Arq.getInstance().model.getServerUrl()+"/funcionalidades/webservice.html";
			var requestVars:URLVariables = new URLVariables();
			var d:Date = new Date();
			requestVars.date = d.fullYear+"-"+(d.month+1).toString()+"-"+d.date;
			requestVars.opt = "getid";
			this._request.data = requestVars;
			this._request.method = URLRequestMethod.GET;
			this._request.url = this._url;
			
			this._urlLoader = new URLLoader();
			this._urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			this._urlLoader.addEventListener(Event.COMPLETE, loaderCompleteUniqueId);
			this._urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			try {
				this._urlLoader.load(this._request);
			} catch (e:Error) {
				trace(e);
			}
		}
		public function sendWinner(id:uint, award:String):void
		{
			this._url = Arq.getInstance().model.getServerUrl()+"/funcionalidades/webservice.html";
			var requestVars:URLVariables = new URLVariables();
			requestVars.id = id;
			requestVars.award = award;
			var d:Date = new Date();
			requestVars.opt = "win";
			requestVars.id = id;
			requestVars.premio = award;
			this._request.data = requestVars;
			this._request.method = URLRequestMethod.GET;
			this._request.url = this._url;
			
			this._urlLoader = new URLLoader();
			this._urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			this._urlLoader.addEventListener(Event.COMPLETE, loaderComplete);
			this._urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			try {
				this._urlLoader.load(this._request);
			} catch (e:Error) {
				trace(e);
			}
		}
		
		public function freePlayer(id:uint, award:String):void
		{
			this._url=Arq.getInstance().model.getServerUrl()+"/funcionalidades/webservice.html";
			var requestVars:URLVariables = new URLVariables();
			requestVars.id = id;
			requestVars.award = award;
			var d:Date = new Date();
			requestVars.date = d.fullYear+"-"+(d.month+1).toString()+"-"+d.date;
			requestVars.opt = "free";
			this._request.data = requestVars;
			this._request.method = URLRequestMethod.GET;
			this._request.url = this._url;
			
			this._urlLoader = new URLLoader();
			this._urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			this._urlLoader.addEventListener(Event.COMPLETE, loaderComplete);
			this._urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			try {
				this._urlLoader.load(this._request);
			} catch (e:Error) {
				trace(e);
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("ORNLoader:ioErrorHandler: " + event.text)
		}
		
		protected function securityErrorHandler(event:Event):void
		{
			trace("securityErrorHandler:" + event.type);
		}
		
		protected function httpStatusHandler(event:HTTPStatusEvent):void
		{
		//	trace("httpStatusHandler:" + event.type);
		}
		
		protected function loaderComplete(event:Event):void
		{
			NavEvents.getInstance().dispatchCustomEvent("SERVICE.COMPLETE", "urlservice", {data:event.target.data});//model
		}
		protected function loaderCompleteUniqueId(event:Event):void
		{
			Arq.getInstance().model.dataXML = new XML(event.target.data);
			NavEvents.getInstance().dispatchCustomEvent("SERVICE.UNIQUEID.COMPLETE", "urlservice", {data:event.target.data});//model
			
		}
	}
}