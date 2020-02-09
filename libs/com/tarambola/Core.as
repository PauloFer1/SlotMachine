package com.tarambola
{
	import be.boulevart.air.utils.ScreenManager;
	
	import com.tarambola.controller.NavEvents;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.UncaughtErrorEvent;

	public class Core
	{
		private var _stage:Stage;
		private var _initEvent:String;
		private var _preLoader:PreLoader;
		private var _topLayer:Sprite;
		
		public function Core()
		{
		}
		public function init(stage:Stage, topLayer:Sprite, window:uint=1, alwaysInFront:Boolean=true, initEvent:String="ALL.LOADED", fullScreen:Boolean=false):void
		{
			this._stage=stage;
			this._stage.nativeWindow.alwaysInFront=alwaysInFront;
			ScreenManager.openWindowCenteredOnScreen(this._stage.nativeWindow, window);
			if(fullScreen)
				this._stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			this._initEvent = initEvent;
			this._topLayer = topLayer;
			
			this._preLoader = new PreLoader();
			this._preLoader.x = this._stage.stageWidth/2 - this._preLoader.width/2;
			this._preLoader.y = this._stage.stageHeight/2 - this._preLoader.height/2;
			
			this._topLayer.addChild(this._preLoader);
			this._preLoader.start();
			
			ErrorDisplay.getInstance().init(stage, topLayer);
			ErrorLog.getInstance().init();
			this._stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, errorLog);
			
			NavEvents.getInstance().addEventListener(initEvent, removeLoader);
		}
	
		//************** HANDLERS *******************//
		protected function errorLog(event:UncaughtErrorEvent):void
		{
			event.preventDefault();
			var e:Error = event.error;
			ErrorLog.getInstance().writeLog(e.message+": "+e.getStackTrace() );
			ErrorDisplay.getInstance().showError("Error:");
			ErrorDisplay.getInstance().showError(event.error["message"]);
		}
		private function removeLoader():void
		{
			this._preLoader.stop();
			this._topLayer.removeChild(this._preLoader);
		}
	}
}