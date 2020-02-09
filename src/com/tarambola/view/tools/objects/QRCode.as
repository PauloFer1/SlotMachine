package com.tarambola.view.tools.objects
{
	import com.tarambola.model.Classes.Arq;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class QRCode extends Sprite
	{
		private var _bg:Image;
		private var _image:Image;
		
		public function QRCode()
		{
			super();
			
			this._bg = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("qrcode.png")));
			
			this.addChild(this._bg);
			
			this.x = Starling.current.stage.stageWidth/2 -  this._bg.width/2;
			this.y = Starling.current.stage.stageHeight/2 - this._bg.height/2 + 120;
		}
		public function addQRCode():void
		{
			if(this._image!=null)
			{
				this._image.texture.dispose();
				this._image.dispose();
			}
			this._image = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("qrcode")));
			this._image.smoothing = TextureSmoothing.TRILINEAR;
			
			this.addChild(this._image);
			
			this._image.x = this._bg.width/2 - this._image.width/2;
			this._image.y = this._bg.height/2 - this._image.height/2;
		}
	}
}