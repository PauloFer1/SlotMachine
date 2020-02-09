package com.tarambola.view
{
	import com.tarambola.ErrorDisplay;
	import com.tarambola.controller.Controller;
	import com.tarambola.controller.NavEvents;
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.model.Classes.Constants;
	import com.tarambola.model.Classes.Fonts;
	import com.tarambola.model.Model;
	import com.tarambola.view.screens.Award;
	import com.tarambola.view.screens.Connect;
	import com.tarambola.view.screens.Loose;
	import com.tarambola.view.screens.Screen;
	import com.tarambola.view.screens.Slot;
	import com.tarambola.view.tools.ui.layout.Background;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	
	
	public class View extends Sprite
	{
		private var model:Model;
		private var controller: Controller;
		
		// STAGE VARS
		private var _timer:Timer;
		private var _screenTimer:Timer;
		private var _resetTimer:Timer;
		private var _renewTimer:Timer;
		
		// SCREENS
		private var _connect:Connect;
		private var _slot:Slot;
		private var _award:Award;
		private var _loose:Loose;
		
		private var _actScreen:Screen;
		private var _nextScreen:Screen;
		
		// LAYOUT
		private var _logo:Image;
		private var _logoCmp:Image;
		private var _background:Background;

		
		
		public function View()
		{
			super();
			
			Arq.getInstance().model.addEventListener("ALL.LOADED", initApp);
		}
		
		protected function initApp(event:Event=null):void
		{
			Starling.current.stage.dispatchEvent(event);			
			
			Arq.getInstance().model.removeEventListener("ALL.LOADED", initApp);
			NavEvents.getInstance().dispatchCustomEvent("ALL.LOADED", "view");//CORE
			
			this._screenTimer = new Timer(5000, 1);
			this._screenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, restart);
			
			this._resetTimer = new Timer(60000, 1);
			this._resetTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timeOut);
			
			this._renewTimer = new Timer(Arq.getInstance().model.getRenewTime()*1000, 1);
			this._renewTimer.addEventListener(TimerEvent.TIMER_COMPLETE, renewQRCode);
			
			// INIT FONTS
			Fonts.getInstance().init();
			
			// INIT SCREENS
			this._connect = new Connect();
			this._slot = new Slot();
			this._award = new Award();
			this._loose = new Loose();
			
			this._background = new Background();
			
			// LAYOUT
			this.buildLayout();
			
			// EVENTS
			NavEvents.getInstance().addEventListener("GOTO.SLOT", gotoSlot);
			NavEvents.getInstance().addEventListener("GAME.OVER", gameOver);
			this.addEventListener(Event.ENTER_FRAME, draw);
			
			//INITIALIZE GAME
			this.startApp();
		}
		
		private function setScreensaver():void
		{
			this._timer = new Timer(100000,0);
			this._timer.addEventListener(TimerEvent.TIMER, gotoScreen);
			this._timer.start();
		}
		private function setRefresh():void
		{
			this._screenTimer = new Timer(120000, 1);
			this._screenTimer.addEventListener(TimerEvent.TIMER_COMPLETE, renewQRCode);
			this._screenTimer.start();
		}
		private function buildLayout():void
		{
			this._logo = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("logo_slot.png")));
			this._logo.x = Starling.current.stage.stageWidth/2 - this._logo.width/2;
			this._logo.y = 34;
			this._logoCmp = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("logo_cmp.png")));
			this._logoCmp.x = Starling.current.stage.stageWidth/2 - this._logoCmp.width/2;
			this._logoCmp.y = Starling.current.stage.stageHeight - this._logoCmp.height-15;
			this._logo.smoothing = TextureSmoothing.TRILINEAR;
			this._logoCmp.smoothing = TextureSmoothing.TRILINEAR;
			
			this.addChild(this._background);
			this.addChild(this._logo);
			this.addChild(this._logoCmp);
			
			//SCREENS
			this.addChild(this._connect);
			this.addChild(this._slot);
			this.addChild(this._award);
			this.addChild(this._loose);
			
		}
		private function startApp(evt:Event = null):void
		{
			ErrorDisplay.getInstance().showError("VERSÃO " + Constants.VERSION);
			this._connect.init();
			this._actScreen=this._connect;
			if(Arq.getInstance().model.getRenewQRCode())
				this._renewTimer.start();
		}
		//******************* NAVIGATION ***********************//
		private function gotoConnect():void
		{
			if(Arq.getInstance().model.getRenewQRCode())
				this._renewTimer.start();
			Constants.getInstance().readyToRoll=false;
			this._nextScreen = this._connect;
			this.removeActScreen();
		}
		private function gotoSlot(evt:Event=null):void
		{
			this._renewTimer.reset();
			this._renewTimer.stop();
			Constants.getInstance().readyToRoll=true;
			var id:uint=evt.data.id;
			Constants.getInstance().actId = id;
			Arq.getInstance().model.getUserInfo(id);
			this._nextScreen = this._slot;
			this.removeActScreen();
			this._resetTimer.start();
		}
		private function gotoAward(evt:Event=null):void
		{
			Constants.getInstance().readyToRoll=false;
			this._nextScreen = this._award;
			this.removeActScreen();
			this._screenTimer.start();
		}
		private function gotoLoose(evt:Event=null):void
		{
			this._renewTimer.reset();
			this._renewTimer.stop();
			Constants.getInstance().readyToRoll=false;
			this._nextScreen = this._loose;
			this.removeActScreen();
			this._screenTimer.start();
		}
		private function removeActScreen():void
		{
			this._actScreen.addEventListener("FADE.FINISH", gotoNav);
			this._actScreen.fadeOut();
		}
		
		private function gotoNav():void
		{
			this._nextScreen.init();
			this._actScreen = this._nextScreen;
		}
		
		private function move():void
		{
		}
		private function gotoHelp():void
		{
			if(!Constants.getInstance().isScreen)
			{
				Constants.getInstance().isScreen
				this.prepareToReload();
				// para Help
				NavEvents.getInstance().dispatchCustomEvent("GOTO.HELP", "view");
			}
		}
		private function prepareToReload():void
		{
		}
		//********************* HANDLERS
		protected function renewQRCode(event:TimerEvent):void
		{
			this._renewTimer.reset();
			this._renewTimer.stop();
			this.restart(event);
		}
		protected function timeOut(event:TimerEvent):void
		{
			this._resetTimer.reset();
			this._resetTimer.stop();
			this.gotoLoose();
		}
		private function gameOver(evt:Event):void
		{
			this._resetTimer.reset();
			this._resetTimer.stop();
			if(evt.data.win)
				this.gotoAward();
			else
				this.gotoLoose();
		}
		protected function restart(event:TimerEvent):void
		{
			this._screenTimer.stop();
			Arq.getInstance().model.addEventListener("ALL.LOADED", restartAux);
			Arq.getInstance().model.getUniqueId();
		}
		private function restartAux():void
		{
			Arq.getInstance().model.removeEventListener("ALL.LOADED", restartAux);
			this._slot.restart();
			
			this._nextScreen = this._connect;
			this.removeActScreen();
			if(Arq.getInstance().model.getRenewQRCode())
				this._renewTimer.start();
		}
		private function resetTimer():void
		{
			this._timer.reset();
			this._timer.start();
		}
		private function gotoScreen(evt:TimerEvent=null):void
		{
			if(!Constants.getInstance().isScreen)
			{
				this.gotoHelp();
				// para horizontallayoutscreen
				NavEvents.getInstance().dispatchCustomEvent("START.SCREEN", "view");
			}
		}
		private function startFicha():void
		{
		}
		private function draw():void
		{
		}
	}
}