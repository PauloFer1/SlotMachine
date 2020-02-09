package com.tarambola.view.screens
{
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.model.Classes.Constants;
	import com.tarambola.model.Classes.Fonts;
	import com.tarambola.view.tools.objects.QRCode;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class Connect extends Screen
	{
		private var _title:TextField;
		private var _code:QRCode;
		private var _titleTween:Tween;
		private var _titleTimer:Timer;
		private var _index:uint=0;
		private var _nextTitle:String;
		private var _label:Image;
		
		public function Connect()
		{
			super();
			this.build();
		}
		public function build():void
		{
			this._titleTimer = new Timer(3000, 1);
			this._titleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, loopTween);
			
			this._label = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("label1.png")));
			this._label.x = Starling.current.stage.stageWidth/2 - this._label.width/2;
			this._label.y = 245;
			
			var font:BitmapFont;
			font = Fonts.getInstance().getFont(Constants.FONT_TITLE2);
			this._title = new TextField(1200, 200, "CONNECT TO WI-FI", font.name, 60, 0xFFFFFF);
			this._title.hAlign = HAlign.CENTER;
			this._title.vAlign = VAlign.CENTER;
			
			this._title.x = Starling.current.stage.stageWidth/2 - this._title.width/2;
			this._title.y = 205;
			
			this._code = new QRCode();
			
			this.addChild(this._label);
			this.addChild(this._title);
			this.addChild(this._code);
			this.alpha=0;
		}
		public override function init():void
		{
			super.init();
			this._code.addQRCode();
			this._titleTimer.reset();
			this._index=0;
			this._title.alpha=1;
			this._title.text = Arq.getInstance().model.getConnectMSG()[0];
			this._titleTimer.start();
		}
		public override function fadeOut():void
		{
			super.fadeOut();
			this._titleTimer.stop();
		}
		private function loopTween(evt:TimerEvent=null):void
		{
			this._titleTimer.reset();
			this._titleTimer.stop();
			switch(this._index)
			{
				case 0:
				{
					this._nextTitle = Arq.getInstance().model.getConnectMSG()[1];
					this._index++;
					break;
				}
				case 1:
				{
					this._nextTitle = Arq.getInstance().model.getConnectMSG()[2];
					this._index++;
					break;
				}	
				case 2:
				{
					this._nextTitle = Arq.getInstance().model.getConnectMSG()[0];
					this._index=0;
					break;
				}	
			}
			this.changeText();
		}
		private function changeText():void
		{
			this._titleTween = new Tween(this._title, 0.3);
			this._titleTween.fadeTo(0);
			this._titleTween.onComplete = finishFadeOutTitle;
			Starling.juggler.add(this._titleTween);
		}
		private function finishFadeOutTitle():void
		{
			Starling.juggler.remove(this._titleTween);
			this._titleTween=null;
			
			this._title.text = this._nextTitle;
			
			this._titleTween = new Tween(this._title, 0.3);
			this._titleTween.fadeTo(1);
			this._titleTween.onComplete = finishFadeInTitle;
			Starling.juggler.add(this._titleTween);
		}
		
		private function finishFadeInTitle():void
		{
			Starling.juggler.remove(this._titleTween);
			this._titleTween=null;
			
			this._titleTimer.start();
		}
	}
}