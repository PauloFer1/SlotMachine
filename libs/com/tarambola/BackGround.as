package com.tarambola
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class BackGround extends Sprite
	{
		private var bg:Bitmap;
		private var _stage:Stage;
		private var _cont:Sprite;
		
		public function BackGround(bg:Bitmap, st:Stage)
		{
			super();
			this.bg=bg;
			this._stage=st;
			this._cont= new Sprite();
			this.placeBg();
		}
		private function placeBg():void
		{
			this.bg.width=this._stage.stageWidth;
			this.bg.height=this._stage.stageHeight;
			this._cont.addChild(this.bg);
		}
		public function get BG():Sprite
		{
			return(this._cont);
		}
	}
}