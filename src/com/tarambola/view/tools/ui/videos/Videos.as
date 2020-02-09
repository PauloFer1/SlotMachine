package com.tarambola.view.tools.ui.videos
{
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.model.Classes.PresidentModel;
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class Videos extends Sprite
	{
		private var _dialId:uint;
		private var _layer:Sprite;
		private var _videos:Vector.<Video>;
		private var _tweens:Vector.<Tween>;
		
		public function Videos(id:uint)
		{
			super();
			this._dialId = id;
			this._videos = new Vector.<Video>;
			this._tweens = new Vector.<Tween>;
		}
		public function show():void
		{
			for(var i:uint=0; i<this._videos.length; i++)
			{
				var rot:Number = (Math.random() * 0.2) + (Math.random() * -0.2); 
				this._tweens[i] = new Tween(this._videos[i], 0.3, Transitions.EASE_IN);
				this._tweens[i].onComplete = onCompleteTween;
				this._tweens[i].onCompleteArgs = [i];
				this._tweens[i].animate("rotation", rot);
				this._tweens[i].delay = 0.1*i;
				this._tweens[i].fadeTo(1);
				this._tweens[i].scaleTo(this._videos[i]._scale);
				Starling.juggler.add(this._tweens[i]);
			}
		}
		public function hide():void
		{
			for(var i:uint=0; i<this._videos.length; i++)
			{
				this._tweens[i] = new Tween(this._videos[i], 0.3, Transitions.EASE_IN);
				this._tweens[i].onComplete = onCompleteTweenHide;
				this._tweens[i].onCompleteArgs = [i];
				this._tweens[i].animate("rotation", 0);
				this._tweens[i].animate("x", this._videos[i]._pos.x);
				this._tweens[i].animate("y", this._videos[i]._pos.y);
				this._tweens[i].fadeTo(0);
				this._tweens[i].scaleTo(0.1);
				Starling.juggler.add(this._tweens[i]);
			}
		}
		//***** HANDLERS
		private function onCompleteTween(it:uint):void
		{
			Starling.juggler.remove(this._tweens[it]);
			this._tweens[it] = null;
		}
		private function onCompleteTweenHide(it:uint):void
		{
			Starling.juggler.remove(this._tweens[it]);
			this._tweens[it] = null;
			
			if(it==this._videos.length-1)
				this.disposeTemporarily();
		}
		//****** PUBLIC METHODS
		public function populate(id:uint, pos:Point):void
		{
			var president:PresidentModel = Arq.getInstance().model.getPresidentOrderById(id);
			
			for(var i:uint=0; i<president.videos.length; i++)
			{
				if(president.videos[i]!=null && president.videos[i]!="")
				{
					var v:Video = new Video(this._dialId, president.videos[i], pos);
					v.alpha = 0;
					v.scaleX = v.scaleY = 0.1;
					this._layer.addChild(v);
					this._videos.push(v);
				}
			}
			this.show();
		}
		public function disposeTemporarily():void
		{
			for(var i:uint =0; i<this._videos.length; i++)
			{
				this._layer.removeChild(this._videos[i]);
				this._videos[i].disposeTemporarily();
			}
			this._videos = new Vector.<Video>;
		}
		///***** GETES & SETS
		public function set layer(layer:Sprite):void
		{
			this._layer = layer;
		}
	}
}