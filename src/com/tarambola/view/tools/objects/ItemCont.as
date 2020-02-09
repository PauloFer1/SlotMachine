package com.tarambola.view.tools.objects
{
	import com.tarambola.DelayCall;
	import com.tarambola.controller.NavEvents;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ItemCont extends Sprite
	{
		private var _id:uint;
		private var _itens:Vector.<Item>;
		private var _acceleration:uint;
		private var _velocity:uint=50;
		private var _timer:Timer;
		private var _count:uint=50;
		public var _actId:uint;
		private const ACELERATION_TIMES:uint=50;
		private var _stopIndex:uint;
		private var _okToStop:Boolean=false;
		private var _alignPos:Number = 481.5;
		
		public function ItemCont(id:uint)
		{
			super();
			this._id=id;
			this._itens = new Vector.<Item>;
			this._timer = new Timer(65,ACELERATION_TIMES);
			this.build();
		}
		public function build():void
		{
			for(var i:uint=0; i<5; i++)
			{
				var it:Item = new Item((i%5)+1, i.toString(), ((i%5)+1).toString()+".png");
				this._itens.push(it);		
				it.y=i*it.height;
				this.addChild(it);
			}
		}
		public function startRoll():void
		{
			this._okToStop=false;
			this._timer.reset();
			this._timer.stop();
			this._timer.addEventListener(TimerEvent.TIMER, countDown);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeOver);
			this._velocity = 50;
			this._count=ACELERATION_TIMES;
			this.addEventListener(Event.ENTER_FRAME, roll);
		}
		private function removeEvent():void
		{
			this.removeEventListener(Event.ENTER_FRAME, roll);
		}
		public function roll(evt:Event=null):void
		{
			if(this._id!=0 && this._okToStop==true && this._stopIndex==this._itens[this.getFstItem()]._id)
			{
				this._okToStop=false;
				this.startCountDown();
			}
			for(var i:uint=0; i<this._itens.length; i++)
			{
				this._itens[i].y=(this._itens[i].y+this._velocity) % (this._itens[i].height*this._itens.length);
			}
		}
		public function stopOn(index:uint):void
		{
			if(index == 1)
				index=this._itens.length;
			else
				index--;
			this._stopIndex=index;
			this._okToStop=true;
		}
		private function snap():void
		{
			var up:Number=10000000;
			var k:uint=0;
			var p:Point = this.getItemAligned();
			k=p.x;
			up=p.y;
			this._actId = this._itens[k]._id;
			if(this._id==0)
			{
				this.snapAuto(up);
			}
			else
			{
				snapAuto(up);
			}
		}
		private function snapAuto(move:Number):void
		{
			for(var i:uint=0; i<this._itens.length; i++)
			{
				var _y:Number = this._itens[i].y-move;
				var t:Tween = new Tween(this._itens[i], 0.5, Transitions.EASE_OUT);
				t.moveTo(0, _y);
				t.onComplete = finishSpin;
				Starling.juggler.add(t);
			}
		}
		private function snapUp(move:Number):void
		{
			for(var i:uint=0; i<this._itens.length; i++)
			{
				var _y:Number = this._itens[i].y-move;
				var t:Tween = new Tween(this._itens[i], 0.4, Transitions.EASE_OUT);
				t.moveTo(0, _y);
				t.onComplete = finishSpin;
				Starling.juggler.add(t);
			}
		}
		
		private function finishSpin():void
		{
			// TODO Auto Generated method stub
			
		}
		private function snapDown(move:Number):void
		{
			for(var i:uint=0; i<this._itens.length; i++)
			{
				var _y:Number = this._itens[i].y+(this._itens[0].height-move);
				var t:Tween = new Tween(this._itens[i], 0.4);
				t.moveTo(0, _y);
				t.onComplete = finishSpin;
				Starling.juggler.add(t);
			}
		}
		public function startCountDown():void
		{
			this._timer.start();
		}
		protected function timeOver(event:TimerEvent):void
		{
			this._timer.removeEventListener(TimerEvent.TIMER, countDown);
			this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timeOver);
			this._timer.stop();
			this.removeEvent();
			this.snap();
			NavEvents.getInstance().dispatchCustomEvent("END.SPIN", "itemcont");//machine
		}
		
		protected function countDown(event:TimerEvent):void
		{
			this._count--;
			this._velocity=this._count;
		}
		private function getFstItem(index:Number=-1):uint
		{
			var up:uint=10000000;
			var k:uint=0;
			for(var i:uint=0; i<this._itens.length; i++)
			{
				if(this._itens[i].y<up)
				{
					up=this._itens[i].y;
					k=i;
				}
			}
			var final:uint;
			if((k+index)>0 && (k+index)>this._itens.length-1)
			{
				final = (k+index)-this._itens.length;
			}
			if((k+index)<0)
			{
				final = (this._itens.length)+(k+index)
			}
			else
			{
				final = k+index;
			}
			
			return(final);
		}
		private function getItemAligned():Point
		{
			var up:Number=10000000;
			var k:uint=0;
			for(var i:uint=0; i<this._itens.length; i++)
			{
				if(Math.abs(this._itens[i].y-this._alignPos)<Math.abs(up-this._alignPos))
				{
					up=this._itens[i].y;
					k=i;
				}
			}
			return(new Point(k, up-this._alignPos));
		}
		public function reposition():void
		{
			for(var i:uint=0; i<this._itens.length; i++)
			{		
				this._itens[i].y=i*this._itens[i].height;
			}
		}
		public function length():uint
		{
			return(this._itens.length);
		}
	}
}