package com.tarambola.view.tools.objects
{
	import com.tarambola.model.Classes.Arq;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Item extends Sprite
	{
		public var _id:uint;
		private var _name:String;
		private var _image:Image;
		
		public function Item(id:uint, name:String, image:String)
		{
			super();
			this._id = id;
			this._name = name;
			trace(image);
			this._image = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage(image)));
			
			this.addChild(this._image);
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update():void
		{
			//if(this._id==3)
				//trace(this.localToGlobal(new Point(0,0))+" - "+this._name);
		}
	}
}