package com.tarambola.controller
{
	public class TweenController
	{
		static private var _instance:TweenController;
		
		private var _tweens:uint=0;
		
		public function TweenController(SingletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():TweenController
		{
			if(TweenController._instance == null)
			{
				TweenController._instance = new TweenController(new SingletonEnforcer());
			}
			return(TweenController._instance);
		}
		public function addTween():void
		{
			this._tweens++;
		}
		public function removeTween():void
		{
			this._tweens--;
		}
		public function hasTween():Boolean
		{
			if(this._tweens>0)
				return true;
			return false;
		}
	}
}
class SingletonEnforcer {}