package com.tarambola.view.tools.objects
{
	import com.tarambola.DelayCall;
	import com.tarambola.controller.NavEvents;
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.model.Classes.Constants;
	import com.tarambola.model.Classes.URLService;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Machine extends Sprite
	{
		private var _filas:Vector.<ItemCont>;
		private var _container:Sprite;
		private var _layer:Image;
		private var _layerLoose:Image;
		private var _mask:Sprite;
		private var _bg:Quad;
		private var _spins:uint=0;
		private var _glow:Image;
		private var _glowTween:Tween;
		private var _glowTimer:Timer;
		
		private var _won:Boolean = false;
		
		private var _prob:Number;
		private var _probWin:Boolean=false;
		private const POSPLUS:uint=50;
		
		public function Machine()
		{
			super();
			//EVENTS
			NavEvents.getInstance().addEventListener("ROLL.MACHINE", roll);
			NavEvents.getInstance().addEventListener("END.SPIN", endSpin);
			
			this._layer = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("slot_layer.png")));
			this._layer.x = Starling.current.stage.stageWidth/2 - this._layer.width/2;
			this._layer.y = Starling.current.stage.stageHeight/2 - this._layer.height/2+POSPLUS;
			
			this._glow = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("glow.png")));
			this._glow.x = Starling.current.stage.stageWidth/2-this._glow.width/2;
			this._glow.y = Starling.current.stage.stageHeight/2-this._glow.height/2+POSPLUS;
			this._glow.alpha=0
				
			this._layerLoose = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("layer_loose.png")));
			this._layerLoose.x = Starling.current.stage.stageWidth/2-this._layerLoose.width/2;
			this._layerLoose.y = Starling.current.stage.stageHeight/2-this._layerLoose.height/2+POSPLUS;
			this._layerLoose.alpha=0;
			
			this._container = new Sprite();
			this._bg = new Quad(749, 274, Arq.getInstance().model.getColorBg());
			
			this._filas = new Vector.<ItemCont>;
			for(var i:uint=0; i<3; i++)
			{
				var cont:ItemCont = new ItemCont(i);
				this._filas[i] = cont;
				cont.x=i*(cont.width +14);
				cont.y=Starling.current.stage.stageHeight/2 - this._filas[i].height/2+POSPLUS;
				this._container.addChild(cont);
			}
			
			this._bg.x = Starling.current.stage.stageWidth/2 - this._bg.width/2-3;
			this._bg.y = this._layer.y+6;
			this._container.x = Starling.current.stage.stageWidth/2 - this._container.width/2;
			// MASK MACHINE FROM ITENS
			this._container.clipRect = new Rectangle(0,this._layer.y+6,750, 273);
			
			this.addChild(this._bg);
			this.addChild(this._container);
			this.addChild(this._layer);
			this.addChild(this._glow);
			this.addChild(this._layerLoose);
			
			this._glowTimer = new Timer(2000, 1);
			this._glowTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endScreen);
		}
		
		private function roll():void
		{
			if(Constants.getInstance().readyToRoll==true)
			{
				this._prob = Arq.getInstance().model.getProbabilities();
				var prizePerHour:uint = Math.abs(Arq.getInstance().model.getMaxPrize()/24);
				var factorComp:Number =(1/prizePerHour);
				var inc: Number = this._prob/prizePerHour;
				var f:Number;
				if(Arq.getInstance().model.getActPrize()>=Arq.getInstance().model.getMaxPrize())
					this._prob=1;
				else
				{
					for(var k:Number=prizePerHour; k>0; k--)
					{
						if(Arq.getInstance().model.getLastPrize()>10000*(factorComp*k))
						{
							f=10000*(factorComp*k);
							var p:Number = this._prob-(inc*k);
							if(p<0)
								this._prob=0;
							else
								this._prob=p;
							k=0;
						}
					}
				}
				for(var i:uint=0; i<this._filas.length; i++)
				{
					DelayCall.call(waitRoll, 500*i, [i]);
				}
				var win:Number = Math.random();
				if(win>this._prob)
				{
					this._probWin=true;
				}
				else
					this._probWin=false;
				var rand:Number = 2000 + Math.random()*2000;
				DelayCall.call(startCountDown, rand);
				Constants.getInstance().readyToRoll=false;
			}
		}
		private function startCountDown():void
		{
			this._filas[0].startCountDown();
		}
		private function waitRoll(index:uint):void
		{
			this._filas[index].startRoll();
		}
		private function looseAux():uint
		{
			var r:uint = uint(Math.random()*(this._filas[0].length()-1));
			return(r+1);
		}
		private function endSpin():uint
		{
			var r:uint;
			if(this._spins==0)
			{
				if(this._probWin)
					this._filas[1].stopOn(this._filas[0]._actId);
				else
				{
					r=this.looseAux();
					while(r==this._filas[0]._actId)
						r=this.looseAux();
					this._filas[1].stopOn(r);
				}
			}
			else if(this._spins==1)
			{
				if(this._probWin)
					this._filas[2].stopOn(this._filas[0]._actId);
				else
				{
					r=this.looseAux();
					while(r==this._filas[0]._actId)
						r=this.looseAux();
					this._filas[2].stopOn(r);
				}
			}
			this._spins++;
			if(this._spins==3)
			{
				this._spins=0;
				if(this._filas[0]._actId==this._filas[1]._actId && this._filas[1]._actId==this._filas[2]._actId)
				{
					var ser:URLService = new URLService();
					ser.sendWinner(Constants.getInstance().actId, this._filas[0]._actId.toString());
					this._won = true;
					this._glowTimer.start();
					this.win();
					return(1);
				}
				else
				{
					this._won = false;
					this._glowTimer.start();
					this.loose();
					return(0);
				}
			}
			this._won=false;
			return(0);
		}
		private function loose():void
		{			
			Starling.juggler.remove(this._glowTween);
			this._glowTween=null;
			
			this._glowTween = new Tween(this._layerLoose, 0.3);
			this._glowTween.fadeTo(1);
			this._glowTween.onComplete = completeLoose;
			Starling.juggler.add(this._glowTween);
		}
		private function win():void
		{			
			Starling.juggler.remove(this._glowTween);
			this._glowTween=null;
			
			this._glowTween = new Tween(this._glow, 0.3);
			this._glowTween.fadeTo(1);
			this._glowTween.onComplete = completeWin;
			Starling.juggler.add(this._glowTween);
		}
		
		private function completeWin():void
		{
			Starling.juggler.remove(this._glowTween);
			this._glowTween=null;
			
			this._glowTween = new Tween(this._glow, 0.3);
			this._glowTween.fadeTo(0);
			this._glowTween.onComplete = win;
			Starling.juggler.add(this._glowTween);
		}
		private function completeLoose():void
		{
			Starling.juggler.remove(this._glowTween);
			this._glowTween=null;
			
			this._glowTween = new Tween(this._layerLoose, 0.3);
			this._glowTween.fadeTo(0);
			this._glowTween.onComplete = loose;
			Starling.juggler.add(this._glowTween);
		}
		//************************ HANDLERS ******************************//
		protected function endScreen(event:TimerEvent):void
		{
			this._glowTimer.stop();
			
			Starling.juggler.remove(this._glowTween);
			this._glowTween=null;
			
			NavEvents.getInstance().dispatchCustomEvent("GAME.OVER", "machine", {win:this._won});
		}
		//*********************** PUBLIC METHODS ***************************//
		public function restart():void
		{
			this._layerLoose.alpha=0;
			this._glow.alpha=0;
			for(var i:uint=0; i<this._filas.length; i++)
			{
				this._filas[i].reposition();
			}
		}
	}
}