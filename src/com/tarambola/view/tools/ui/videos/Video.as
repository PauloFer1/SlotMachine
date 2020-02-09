package com.tarambola.view.tools.ui.videos
{
	
	import com.tarambola.model.Classes.Arq;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.video.StarlingVideo;
	
	public class Video extends Sprite
	{
		
		private var _video:StarlingVideo;
		private var _path:String;
		public var _scale:Number;
		public var _pos:Point;
		private var _playBtn:Button;
		private var _player:Player;
		private var _dialId:uint;
		
		private var _isPLay:Boolean = false;
		
		public function Video(id:uint, path:String, pos:Point)
		{
			super();
			this._dialId = id;
			this._path = path;
			
			this._pos = pos;
			this.x = pos.x;
			this.y = pos.y;
			
			this.initialize();
		}
		private function initialize():void
		{
			this._video = new StarlingVideo(this._path);
			this._video.init(new Rectangle(0,0,800,600), 24);
			this.addChild(this._video);
			
			this._player = new Player();
			this.addChild(this._player);
			
			this._playBtn = new Button(Arq.getInstance().model.asset.getTexture("play_btn"));
			this._playBtn.pivotX = this._playBtn.pivotY = this._playBtn.width/2;
			this._playBtn.x = this._video.width/2;
			this._playBtn.y = this._video.height/2;
			this.addChild(this._playBtn);
			this._playBtn.addEventListener(Event.TRIGGERED, playVideo);
			
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, update);
			this._player.addEventListener("PLAY", playVideo);
			this._player.addEventListener("PAUSE", pauseVideo);
			this._player.addEventListener("SEEK", seek);
			this._video.addEventListener("REARRANGE", reArrange);
			this._video.addEventListener("FINISH", finishVideo);
			
			this.pivotX = this._video.width/2;
			this.pivotY = this._video.height/2;
			
			this._player.x = this._video.width/2;
			this._player.y = this._video.height;
			this._player.visible = false;
			this._player.touchable = false;
			
			this.setScale();
			
		}
		
		private function reArrange():void
		{
			
			this.setScale();
		
			this.pivotX = this._video.width/2;
			this.pivotY = this._video.height/2;
			
			this._player.scaleX = 0.3;
			this._player.scaleY = 0.3;
			this._player.x = this._video.width/2 - this._player.width/2;
			this._player.y = this._video.height + 5;
			
			this._playBtn.x = this._video.width/2;
			this._playBtn.y = this._video.height/2;
		}
		private function setScale():void
		{
			var ratio:Number=1;
			if(this._video.width>this._video.height)
			{
				if(this._video.width>260)
				{
					ratio = 260/this._video.width;
				}
			}
			else
			{
				if(this._video.width>190)
				{
					ratio = 190/this._video.width;
				}
			}
			this._video.scaleX = ratio;
			this._video.scaleY = ratio;
			this.scaleX = this.scaleY = ratio;
			this._scale = ratio;
		}
		public function disposeTemporarily():void
		{
			this._playBtn.visible = true;
			this._playBtn.touchable = true;
			this._video._stop();
			this._isPLay = false;
			this._player.visible = false;
			this._player.touchable = false;
			this._player.restart();
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			this.removeEventListener(Event.ENTER_FRAME, update);
			this._player.removeEventListener("PLAY", playVideo);
			this._player.removeEventListener("PAUSE", pauseVideo);
			this._player.removeEventListener("SEEK", seek);
			this._video.removeEventListener("REARRANGE", reArrange);
			this._video.removeEventListener("FINISH", finishVideo);
		}
		//******* HANDLERS
		private function playVideo():void
		{
			this._video._resume();
			this._playBtn.visible = false;
			this._playBtn.touchable = false;
			this._player.visible = true;
			this._player.touchable = true;
			this._isPLay = true;
		}
		private function pauseVideo():void
		{
			this._video._stop();
			this._isPLay = false;
		}
		private function seek(event:Event):void
		{
			this._video._seek(event.data.pos, event.data.barWidth);
		}
		private function update():void
		{
			if(this._isPLay)
			{
				this._player.update(this._video.minutes, this._video.seconds, this._video.percent);
			}
		}
		private function finishVideo():void
		{
			this._playBtn.visible=true;
			this._playBtn.touchable = true;
			this._player.restart();
			this._isPLay = false;
			this._player.visible = false;
			this._player.touchable = false;
		}
		//**** MULTITOUCH
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			
			if (touches.length == 1)
			{
				// one finger touching -> move
				var limit:Number;
				if(this._dialId == 1)
					limit = -380;
				else
					limit = 380;
				var delta:Point = touches[0].getMovement(this.parent);
				if((limit==-380 && (this.x+delta.x)>limit) || (limit==380 && (this.x+delta.x)<limit) )
				{
					this.x += delta.x;
					this.y += delta.y;
				}
			}            
			else if (touches.length == 2)
			{
				// two fingers touching -> rotate and scale
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = touchA.getLocation(this.parent);
				var previousPosA:Point = touchA.getPreviousLocation(this.parent);
				var currentPosB:Point  = touchB.getLocation(this.parent);
				var previousPosB:Point = touchB.getPreviousLocation(this.parent);
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number = currentAngle - previousAngle;
				
				// update pivot point based on previous center
				var previousLocalA:Point  = touchA.getPreviousLocation(this);
				var previousLocalB:Point  = touchB.getPreviousLocation(this);
				
				// rotate
				this.rotation += deltaAngle;
				
				// scale
				var sizeDiff:Number = currentVector.length / previousVector.length;
				this.scaleX *= sizeDiff;
				this.scaleY *= sizeDiff;
			}
			
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			
			if (touch && touch.tapCount == 1)
				parent.addChild(this); // bring self to front
		}
	}
}