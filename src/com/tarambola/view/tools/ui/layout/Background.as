package com.tarambola.view.tools.ui.layout
{
	import com.tarambola.model.Classes.Arq;
	
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	

	public class Background extends Sprite
	{
		private var _image:Image;
		
		public function Background()
		{
			this.initialize();
		}
		private function initialize():void
		{
			this._image = new Image(Arq.getInstance().model.asset.getTexture("background"));
			this.addChild(this._image);
		}
	}
}