package com.tarambola
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class ErrorLog
	{
		static private var _instance:ErrorLog;
		
		private var _log:File;
		private var _logStream:FileStream;
		private var _logString:String;
		
		public function ErrorLog(SingletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():ErrorLog
		{
			if(ErrorLog._instance == null)
			{
				ErrorLog._instance = new ErrorLog(new SingletonEnforcer());
			}
			return(ErrorLog._instance);
		}
		public function init():void
		{
			this._log = File.applicationStorageDirectory.resolvePath("log.txt");
			this._logStream = new FileStream();
			this._logStream.open(this._log, FileMode.UPDATE);
			this._logString = this._logStream.readMultiByte(this._log.size, File.systemCharset);
			this._logStream.addEventListener(flash.events.Event.CLOSE, fileClosed);
		}
		public function writeLog(log:String):void
		{
			trace("LOG: "+log);
			this._logString="\n"+(new Date()).toString()+":\t"+log;
			this._logStream.writeUTFBytes(this._logString);
		}
		protected function fileClosed(event:Event):void
		{
		}
		public function closeFile():void
		{
			this._logStream.close();
		}
		
	}
}
class SingletonEnforcer {}