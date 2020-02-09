package com.tarambola.view.screens
{
	import feathers.controls.Screen;
	
	import starling.animation.Tween;
	import starling.core.Starling;
		
	public class Screen extends feathers.controls.Screen
	{
		private var _fadeTween: Tween;
		
		public function Screen()
		{
			super();
		}
		public function init():void
		{
			this._fadeTween = new Tween(this, 0.5);
			this._fadeTween.fadeTo(1);
			this._fadeTween.onComplete = finishFade;
			Starling.juggler.add(this._fadeTween);
			
		}
		private function finishFade():void
		{
			Starling.juggler.remove(this._fadeTween);
			this._fadeTween=null;
		}
		public function fadeOut():void
		{
			Starling.juggler.remove(this._fadeTween);
			this._fadeTween=null;
			
			this._fadeTween = new Tween(this, 0.5);
			this._fadeTween.fadeTo(0);
			this._fadeTween.onComplete = finishFadeOut;
			Starling.juggler.add(this._fadeTween);
		}
		private function finishFadeOut():void
		{
			Starling.juggler.remove(this._fadeTween);
			this._fadeTween=null;
			this.dispatchEventWith("FADE.FINISH");
		}
	}
}