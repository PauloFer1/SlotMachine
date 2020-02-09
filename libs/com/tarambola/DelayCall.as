package com.tarambola
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class DelayCall
	{
		private var _func:Function;
		private var _timer:Timer;
		private var _args:Array;
		
		public function DelayCall(func:Function=null, secs:Number=0, count:uint=1, args:Array=null)
		{
			this._func = func;
			this._args = args;
			this._timer = new Timer(secs*1000, count);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, exec);
		}
		protected function exec(event:TimerEvent):void
		{
			//this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, exec);
			this._timer.stop();
			this._func.apply(null, this._args);
		}
		//**** PUBLIC METHODS
		public function setParams(func:Function=null, secs:Number=0, count:uint=1, args:Array=null):void
		{
			this._func = func;
			this._args = args;
			this._timer = new Timer(secs*1000, count);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, exec);
		}
		public function start():void
		{
			this._timer.start();
		}
		public function stop():void
		{
			this._timer.stop();
		}
		public function reset():void
		{
			this._timer.reset();
		}
		public static function call(func:Function, secs:Number, args:Array=null):Timer
		{
			var timer:Timer = new Timer(secs, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{timer.stop();func.apply(null, args)});
			timer.start();
			return(timer);
		}
		public function updateTime(secs:Number):void
		{
			this._timer.delay = (secs*1000);
		}
	}
}