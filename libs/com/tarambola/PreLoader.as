package com.tarambola
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PreLoader extends Sprite
	{
		private var _quads:Vector.<Shape>;
		private var _timer:Timer;
		private var _actQuad:uint=0;
		
		public function PreLoader()
		{
			super();
			this._quads = new Vector.<Shape>;
			
			for(var i:uint=0; i<4; i++)
			{
				this._quads[i] = Draw.dRect(100,100,0x222222);
				this._quads[i].alpha=0;
				this.addChild(this._quads[i]);
			}
			this._quads[0].x=0;
			this._quads[0].y=0;
			this._quads[1].y=0;
			this._quads[1].x=this._quads[0].width+10;
			this._quads[3].x=this._quads[0].width+10;
			this._quads[2].x=0;
			this._quads[2].y=this._quads[0].height+10;
			this._quads[3].y=this._quads[0].height+10;
			
			this._timer = new Timer(500, 1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			if(this._actQuad>=4)
				this._actQuad=0;
			var a:Number=0.6;
			if(this._quads[this._actQuad].alpha!=0)
				a=0;
			this._quads[this._actQuad].alpha=a;
			
			this._timer.stop();
			this._timer.reset();
			this._timer.start();
			this._actQuad++;
		}
		
		public function start():void
		{
			this._timer.start();
		}
		public function stop():void
		{
			this._timer.stop();
		}
	}
}