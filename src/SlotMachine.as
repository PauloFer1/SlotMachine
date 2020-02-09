package
{
	import com.tarambola.Core;
	import com.tarambola.ErrorDisplay;
	import com.tarambola.controller.Controller;
	import com.tarambola.controller.NavEvents;
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.model.Model;
	import com.tarambola.view.View;
	import com.tarambola.view.screens.Help;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(frameRate="60", width="1080", height="1920", backgroundColor="#2A2A2A")]
	public class SlotMachine extends Sprite
	{
		private const APP_WIDTH: int = 1080;
		private const APP_HEIGHT: int = 1920;

		//**** ARQUITECTURE
		private var model:Model;
		private var view:View;
		private var controller:Controller;
		private var _core:Core;
		
		//**** GPU INSTANCE
		private var starling:Starling;
		
		//**** HELPERS
		private var timer:Timer;
		
		private var _help:Help;
		
		public function SlotMachine()
		{
			super();
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.nativeWindow.visible = true;
			if(!Capabilities.isDebugger)
				stage.nativeWindow.alwaysInFront=true;
			this._core = new Core();
			
			this.addEventListener(flash.events.Event.ADDED_TO_STAGE, addToStage);
		}
		protected function addToStage(event:flash.events.Event):void
		{
			this.removeEventListener(flash.events.Event.ADDED_TO_STAGE, addToStage);
			
			stage.nativeWindow.width = stage.fullScreenWidth;
			stage.nativeWindow.height = stage.fullScreenHeight;
			stage.stageWidth = stage.fullScreenWidth;
			stage.stageHeight = stage.fullScreenHeight;
			
			var always:Boolean=false;
			if(!Capabilities.isDebugger)
				always=true;
			if(!Capabilities.isDebugger)
				this._core.init(stage, this, 1, always, "ALL.LOADED", true);
			else
				this._core.init(stage, this, 1, always, "ALL.LOADED", true);

			
			var stageWidth:int   = stage.nativeWindow.width;
			var stageHeight:int  = stage.nativeWindow.height;
			
			var sx:Number = stageWidth/APP_WIDTH;
			var sy:Number = stageHeight/APP_HEIGHT;
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, APP_WIDTH, APP_HEIGHT),
				ScaleMode.NO_BORDER);
			
			ErrorDisplay.getInstance().init(stage, this);
			ErrorDisplay.getInstance().showError("A INICIAR...");
			
			//** ARQUITECTURE CONSTRUCTION
			this.model = new Model();
			this.controller = new Controller(this.model);
			Arq.getInstance().init(model, controller);
			
			//** STARLING INITIALIZE
			Starling.multitouchEnabled = false;
			this.starling = new Starling(View, stage, viewPort);
			//** IF EXISTS INITIAL BACKGROUND BEFORE STARLING IS READY
			Starling.current.stage.addEventListener("ALL.LOADED", removeInitBg);
			
			this.starling.viewPort.width = stageWidth;
			this.starling.viewPort.height = stageHeight;
			this.starling.viewPort.y = stageHeight/2 - this.starling.viewPort.height/2;
			this.starling.antiAliasing = 1;
			//******** STATS ********//
			//this.starling.showStats = true;
			//this.starling.showStatsAt("left", "bottom");
			//this.starling.simulateMultitouch = true;
			
			//** WAITING FOR STARLING
			this.starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			
			//** FORCE WINDOW TO FRONT AND HIDE MOUSE
			this.timer = new Timer(500, 1);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, setWindow);
			this.timer.start();
			if(!Capabilities.isDebugger)
				this.hideMouse();	
		}
		private function onRootCreated():void
		{
			this.starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			this.model.init();
			this.model.addEventListener("ALL.LOADED", initHelp);
			this.starling.start();
		}
		private function removeInitBg():void
		{
			// TODO Auto Generated method stub
		}
		private function setWindow(evt:TimerEvent=null):void
		{
			this.timer.stop();
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, setWindow);
			stage.nativeWindow.activate();
			stage.nativeWindow.orderToBack();
			stage.nativeWindow.orderToFront();
			if(!Capabilities.isDebugger)
				Mouse.hide();
		}
		private function hideMouse():void
		{
			stage.nativeWindow.activate();
			stage.nativeWindow.orderToBack();
			stage.nativeWindow.orderToFront();
			Mouse.hide();
		}
		//******** FUNCTIONS
		
		private function initHelp():void
		{
			NavEvents.getInstance().addEventListener("GOTO.HELP", gotoHelp);
		}
		private function gotoHelp():void
		{
			this._help.show();
		}
	}
}