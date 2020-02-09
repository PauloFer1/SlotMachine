package com.tarambola.model.Classes
{
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class Fonts
	{
		[Embed(source="../../../../files/fonts/font1.fnt", mimeType="application/octet-stream")]
		public static const Font1Config:Class;
		
		[Embed(source="../../../../files/fonts/font2.fnt", mimeType="application/octet-stream")]
		public static const Font2Config:Class;
					
		static private var _instance:Fonts;
		
		private var _fonts:Vector.<BitmapFont>;
		
		public function Fonts(SingletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():Fonts
		{
			if(Fonts._instance == null)
			{
				Fonts._instance = new Fonts(new SingletonEnforcer());
			}
			return(Fonts._instance);
		}
		public function init():void
		{
			this._fonts = new Vector.<BitmapFont>;
			
			this._fonts.push(new BitmapFont(Arq.getInstance().model.asset.getTexture("font1"), XML(new Font1Config())));
			this._fonts.push(new BitmapFont(Arq.getInstance().model.asset.getTexture("font2"), XML(new Font2Config())));
			
			this._fonts[0].smoothing = TextureSmoothing.TRILINEAR;
			this._fonts[1].smoothing = TextureSmoothing.TRILINEAR;
			
			TextField.registerBitmapFont(this._fonts[0]);
			TextField.registerBitmapFont(this._fonts[1]);
		}
		public function getFont(name:String):BitmapFont
		{
			for(var i:uint=0; i<this._fonts.length; i++)
			{
				if(name==this._fonts[i].name)
					return(this._fonts[i]);
			}
			return(null);
		}
	}
}
class SingletonEnforcer {}