package com.tarambola
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Layout extends Sprite
	{
		private var _stage:Stage;
		
		private var position:String;
		private var marginVer:int;
		private var marginHor:int;
		private var obj:DisplayObject;
		private var factor:Number;
		
		public static const TOP_LEFT:String = "top_left";
		public static const TOP_RIGHT:String = "top_right";
		public static const TOP_CENTER:String = "top_center";
		public static const BOTTOM_LEFT:String = "bottom_left";
		public static const BOTTOM_RIGHT:String = "bottom_right";
		public static const BOTTOM_CENTER:String = "bottom_center";
		public static const MIDDLE_LEFT:String = "middle_left";
		public static const MIDDLE_RIGHT:String = "middle_right";
		public static const MIDDLE_CENTER:String = "middle_center";
		
		public function Layout(obj:DisplayObject, st:Stage, position:String, scale:Boolean=false, factor:Number=1, marginVer:int=0, marginHor:int=0)
		{
			super();
			this.obj=obj;
			this._stage=st;
			this.factor=factor;
			if(this._stage.stageWidth<1300 && scale)
			{
				this.obj.scaleX=this.factor;
				this.obj.scaleY=this.factor;
			}
			this.position=position;
			if(this._stage.stageWidth<1300 && scale)
			{
				this.marginVer=marginVer*this.factor;
				this.marginHor=marginHor*this.factor;
			}
			else
			{
				this.marginVer=marginVer;
				this.marginHor=marginHor;
			}
			
			this.setlayout();
		}
		private function setlayout():void
		{
			switch(this.position)
			{
				case "top_left":
					this.setTopLeft();
					break;
				case "top_right":
					this.setTopRight();
					break;
				case "top_center":
					this.setTopCenter();
					break;
				case "bottom_left":
					this.setBottomLeft();
					break;
				case "bottom_right":
					this.setBottomRight();
					break;
				case "bottom_center":
					this.setBottomCenter();
					break;
				case "middle_left":
					this.setMiddleLeft();
					break;
				case "middle_right":
					this.setMiddleRight();
					break;
				case "middle_center":
					this.setMiddleCenter();
					break;
			}
		}
		
		//--------------------------------POSITIONING---------------------------------------
		private function setTopLeft():void
		{
			this.obj.x=this.marginHor;
			this.obj.y=this.marginVer;
		}
		private function setTopRight():void
		{
			this.obj.x=this._stage.stageWidth -this.obj.width - this.marginHor;
			this.obj.y=this.marginVer;
		}
		private function setTopCenter():void
		{
			this.obj.x=this._stage.stageWidth/2 - this.obj.width/2 + this.marginHor;
			this.obj.y=this.marginVer;
		}
		private function setBottomLeft():void
		{
			this.obj.x=this.marginHor;
			this.obj.y=this._stage.stageHeight - this.obj.height - this.marginVer;
		}
		private function setBottomRight():void
		{
			this.obj.x=this._stage.stageWidth - this.obj.width - this.marginHor;
			this.obj.y=this._stage.stageHeight - this.obj.height - this.marginVer;
		}
		private function setBottomCenter():void
		{
			this.obj.x=this._stage.stageWidth/2 - this.obj.width/2 + this.marginHor;
			this.obj.y=this._stage.stageHeight - this.marginVer - this.obj.height;
		}
		private function setMiddleLeft():void
		{
			this.obj.x=this.marginHor;
			this.obj.y=this._stage.stageHeight/2 - this.obj.height/2 + this.marginVer;
		}
		private function setMiddleRight():void
		{
			this.obj.x=this._stage.stageWidth - this.obj.width - this.marginHor;
			this.obj.y=this._stage.stageHeight/2 - this.obj.height/2 + this.marginVer;
		}
		private function setMiddleCenter():void
		{
			this.obj.x=this._stage.stageWidth/2 - this.obj.width/2 + this.marginHor;
			this.obj.y=this._stage.stageHeight/2 - this.obj.height/2 + this.marginVer;
		}
		//----------------------------------GETS-----------------------------------
		public function get Obj():DisplayObject
		{
			return(this.obj);
		}
	}
}