package com.tarambola
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Thumb extends Sprite
	{
		private var thumb:Bitmap;
		private var rect:Rectangle;
		private var _container:Sprite;
		private var border:Object; //color, thick, 
		private var _x:int;
		private var _y:int;
		private var crop:Boolean;
		private var resize:Boolean;
		private var borderRect:Shape;
		private var maskR:Shape;
		private var widthOri:Number;
		private var heightOri:Number;
		
		public var id:String;
		
		public function Thumb(thumb:Bitmap, rect:Rectangle, crop:Boolean=false, border:Object=null, resize:Boolean=false, _x:int=0, _y:int=0)
		{
			this.widthOri=thumb.width;
			this.heightOri=thumb.height;
			this.thumb=thumb;
			this.rect=rect;
			this._x=_x;
			this._y=_y;
			this._container= new Sprite();
			this.crop=crop;
			this.border=border
			this.resize=resize;
			
			var r:Number;
			
			if(border!=null)
			{
				this.borderRect = new Draw().dRect(rect.width+(border.thick*2), rect.height+(border.thick*2), border.color);
				this._container.addChild(this.borderRect);
			}
			
			if(thumb.width < thumb.height)
			{
				if(thumb.width > rect.width)
				{
					r = rect.width/thumb.width;
					thumb.height*=r;
					thumb.width=rect.width;
					if(border!=null && crop)
					{
						thumb.x=border.thick;
					}
					thumb.y= rect.height/2 - thumb.height/2;
				}
				else
				{
					r = rect.width/thumb.width;
					thumb.height*=r;
					thumb.width=rect.width;
					thumb.x= rect.width/2 - thumb.width/2;
					thumb.y= rect.height/2 - thumb.height/2;
				}				
			}
			else
			{
				if(thumb.height > rect.height)
				{
					r = rect.height/thumb.height;
					if((thumb.width*r) > rect.width)
					{
						thumb.width*=r;
						thumb.height=rect.height;
						if(border!=null && crop)
						{
							thumb.y=border.thick;
						}
						thumb.x= rect.width/2 - thumb.width/2;
					}
					else
					{
						r = rect.width/thumb.width;
						thumb.height*=r;
						thumb.width=rect.width;
						if(border!=null && crop)
						{
							thumb.x=border.thick;
						}
						thumb.y= rect.height/2 - thumb.height/2;
					}
				}
				else
				{
					thumb.y= rect.height/2 - thumb.height/2;
					thumb.x= rect.width/2 - thumb.width/2;
				}
			}	
			if(crop)
			{
				this.maskR= new Draw().dRect(rect.width, rect.height);
				this._container.addChild(this.maskR);
				thumb.mask=this.maskR;
				this._container.addChild(thumb);

				if(border!=null)
				{
					this.maskR.x=border.thick;
					this.maskR.y=border.thick;
				}
			}
			else
			{
				this._container.addChild(thumb);
			}
			this._container.x=this._x;
			this._container.y=this._y;
			this.addChild(this._container);
		}
		public function _resize(recta:Rectangle):void
		{
			this.thumb.width=this.widthOri;
			this.thumb.height=this.heightOri;
			var r:Number;
			this.rect=recta;
			if(this.border!=null)
			{
				this._container.removeChild(this.borderRect);
				this.borderRect = new Draw().dRect(recta.width+(border.thick*2), recta.height+(border.thick*2), border.color);
				this._container.addChildAt(this.borderRect, 0);
			}
			
			if(thumb.width < thumb.height)
			{
				if(thumb.width > rect.width)
				{
					r = rect.width/thumb.width;
					thumb.height*=r;
					thumb.width=rect.width;
					if(border!=null && crop)
					{
						thumb.x=border.thick;
					}
					thumb.y= rect.height/2 - thumb.height/2;
				}
				else
				{
					r = rect.width/thumb.width;
					thumb.height*=r;
					thumb.width=rect.width;
					thumb.x= rect.width/2 - thumb.width/2;
					thumb.y= rect.height/2 - thumb.height/2;
				}				
			}
			else
			{
				if(thumb.height > rect.height)
				{
					r = rect.height/thumb.height;
					if((thumb.width*r) > rect.width)
					{
						thumb.width*=r;
						thumb.height=rect.height;
						if(border!=null && crop)
						{
							thumb.y=border.thick;
						}
						thumb.x= rect.width/2 - thumb.width/2;
					}
					else
					{
						r = rect.width/thumb.width;
						thumb.height*=r;
						thumb.width=rect.width;
						if(border!=null && crop)
						{
							thumb.x=border.thick;
						}
						thumb.y= rect.height/2 - thumb.height/2;
					}
				}
				else
				{
					thumb.y= rect.height/2 - thumb.height/2;
					thumb.x= rect.width/2 - thumb.width/2;
				}
			}	
			if(this.crop)
			{
				this._container.removeChild(this.maskR);
				this.maskR= new Draw().dRect(recta.width, recta.height );
				this._container.addChild(this.maskR);
				this.thumb.mask=this.maskR;
				
				if(border!=null)
				{
					this.maskR.x=border.thick;
					this.maskR.y=border.thick;
				}
			}
		}
		public function set all(max:Number):void
		{
		
			var r:Number;
			if(this.widthOri>this.heightOri)
			{
				r= max/this.widthOri;
				var h:Number = this.heightOri*r;
				this._resize(new Rectangle(0, 0, max, h));
			}
			else
			{
				r = max/this.heightOri;
				var w:Number = this.widthOri*r;
				this._resize(new Rectangle(0, 0, w, max));
			}
		}
		public function set maxWidth(max:Number):void
		{
			var r:Number;
			r= max/this.widthOri;
			var h:Number = this.heightOri*r;
			this._resize(new Rectangle(0, 0, max, h));
		}
		public function get Clone():Thumb
		{
			var bmpD:BitmapData = this.thumb.bitmapData.clone();
			var bmp:Bitmap = new Bitmap(bmpD);
			var th:Thumb = new Thumb(bmp, this.rect, this.crop, this.border, this.resize, this._x, this._y);
			return(th);
		}
		public function get all():Number
		{
			if(this.rect.width>this.rect.height)
				return(this.rect.width);
			else
				return(this.rect.height);
		}
		public function set _width(w:Number):void
		{
			this._resize(new Rectangle(0, 0, w, this.rect.height));
		}
		public function set _height(h:Number):void
		{
			this._resize(new Rectangle(0, 0, this.rect.width, h));
		}
		public function get _width():Number
		{
			return(this.rect.width);
		}
		public function get _height():Number
		{
			return(this.rect.height);
		}
		public function get bitmap():Bitmap
		{
			return(this.thumb);
		}
		public function get Cont():Sprite
		{
			return(this._container);
		}
		public function get OriWidth():Number
		{
			return(this.widthOri);
		}
		public function get OriHeight():Number
		{
			return(this.heightOri);
		}
	}
}