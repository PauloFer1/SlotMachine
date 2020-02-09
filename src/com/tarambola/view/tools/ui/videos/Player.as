package com.tarambola.view.tools.ui.videos
{
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.model.Classes.Constants;
	import com.tarambola.model.Classes.Fonts;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class Player extends Sprite
	{
		private var _playBtn:Button;
		private var _pauseBtn:Button;
		private var _bg:Quad;
		private var _progressBar:Quad;
		private var _progressBg:Quad;
		private var _tempo:TextField;
		
		public function Player()
		{
			super();
			this.initialize();
		}
		private function initialize():void
		{
			this._playBtn = new Button(Arq.getInstance().model.asset.getTexture("play_btn2"));
			this._pauseBtn = new Button(Arq.getInstance().model.asset.getTexture("pause_btn"));
			
			this._bg = new Quad(460, 84, 0x000000);
			this._bg.alpha = 0.5;
			this._progressBg = new Quad(263, 26, 0xffffff);
			this._progressBg.alpha = 0.2;
			this._progressBar = new Quad(254, 16, 0xffffff);
			this._progressBar.alpha = 0.8;
			
			var font:BitmapFont = Fonts.getInstance().getFont(Constants.FONT_TITLE2);
			this._tempo = new TextField(80, 29, "00:00", font.name, 24, 0xffffff);
			this._tempo.hAlign = HAlign.CENTER;
			this._tempo.vAlign = VAlign.TOP;
			this._tempo.height = this._tempo.textBounds.height + 15;
			this._tempo.x = 370;
			this._tempo.y = 29;
			
			this._playBtn.x = this._pauseBtn.x = 22;
			this._playBtn.y = this._pauseBtn.y = 16;
			
			this._progressBg.x = 96;
			this._progressBg.y = 29;
			this._progressBar.x = this._progressBg.x + 4;
			this._progressBar.y = this._progressBg.y + 5;
			
			this._playBtn.touchable = false;
			this._playBtn.visible = false;
			
			this.addChild(this._bg);
			this.addChild(this._playBtn);
			this.addChild(this._pauseBtn);
			this.addChild(this._progressBg);
			this.addChild(this._progressBar);
			
			this.addChild(this._tempo);
			
			this._progressBar.width = 1;
			this._progressBar.touchable = false;
			
			this._playBtn.addEventListener(Event.TRIGGERED, onPlay);
			this._pauseBtn.addEventListener(Event.TRIGGERED, onPause);
			this._progressBg.addEventListener(TouchEvent.TOUCH, seek);
		}		
		private function onPause():void
		{
			this.dispatchEventWith("PAUSE");
			this._pauseBtn.visible = false;
			this._pauseBtn.touchable = false;
			this._playBtn.visible = true;
			this._playBtn.touchable = true;
		}
		
		private function onPlay():void
		{
			this.dispatchEventWith("PLAY");
			this._playBtn.visible = false;
			this._playBtn.touchable = false;
			this._pauseBtn.visible = true;
			this._pauseBtn.touchable = true;
		}
		private function seek(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch && touch.tapCount == 1)
				this.dispatchEventWith("SEEK", false, {pos:(touch.getLocation(this).x - this._progressBg.x), barWidth:(this._progressBg.width-8)});
				
		}
		public function update(min:uint=0, sec:uint=0, percent:Number=0):void
		{
			this._progressBar.width = percent*(this._progressBg.width-8);
			
			var mins:String;
			var secs:String;
			if(min<10)
				mins = "0"+min.toString();
			else
				mins = min.toString();
			if(sec<10)
				secs = "0"+sec.toString();
			else
				secs = sec.toString();
			
			this._tempo.text = mins+":"+secs;
		}
		public function restart():void
		{
			this._pauseBtn.visible = false;
			this._pauseBtn.touchable = false;
			this._playBtn.visible = true;
			this._playBtn.touchable = true;
		}
	}
}