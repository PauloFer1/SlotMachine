package com.tarambola.model.Classes
{
	import flash.geom.Point;

	public class Constants
	{
		static private var _instance:Constants;
		
		public static const STAGE_WIDTH:int  = 1920;
		public static const STAGE_HEIGHT:int = 1080;
		
		public static const VERSION:Number = 0.9;
		
		private var _scale:Number;
		private var _scaleY:Number;
		
		private var _realWidth:uint;
		private var _realHeight:uint;
		
		//****** PUBLIC CONSTS ********//
		
		//******* FONTS
		public static const FONT_LIST_SIZE:uint = 35;
		public static const FONT_LIST_HIGH_SIZE:uint = 46;
		public static const FONT_TITLE1:String = "font1";
		public static const FONT_TITLE2:String = "font2";
		public static const FONT_TEXT1:String = "GothamHTF-Book";
		public static const FONT_LIST_COLOR:uint = 0x004786;
		public static const FONT_TEXT_COLOR:uint = 0xFFFFFF;
		public static const FONT_FICHA_COLOR:uint = 0X0075bf;
		public static const FONT_FICHA_COLOR2:uint = 0x00265a;
		
		//******** LAYOUT
		public static const ITEM_HEIGHT:uint = 150;
		public static const MARGIN_LEFT_LIST:uint = 132;
		public static const MARGIN_TOP_LIST:uint = 476;
		public var PATTERNS_CORNER:Vector.<String>;
		public var PATTERNS_MIDDLE:Vector.<String>;
		
		//******* LANG
		public static const PT:String = "pt";
		public static const EN:String = "en";
		public static const ES:String = "es";
		
		//******* FLAGS
		public var isScrolling:Boolean = false;
		public var selectedFicha:uint=0;
		public var selectedItem:uint=0;
		public var isScreen:Boolean = false;
		public var readyToRoll:Boolean = false;
		
		public var _isReady:Boolean = true;
		
		public static const ROTATION:Number = 0.02;
		public static const SPACER:Number = 0.5;
		public static const SPACER_CHART:Number = 0.1;
		
		public var actPres:Vector.<uint>;
		public var safeOpen:Vector.<Boolean>;
		
		public var actId:uint=0;
		public var actUniqueId:String="";
		public var attempts:uint=0;

		
		public function Constants(SingletonEnforcer:SingletonEnforcer)
		{
			this.actPres = new Vector.<uint>;
			this.actPres[0] = 0;
			this.actPres[1] = 0;
			this.safeOpen = new Vector.<Boolean>;
			this.safeOpen[0] = true;
			this.safeOpen[1] = true;
		}
		public static function getInstance():Constants
		{
			if(Constants._instance == null)
			{
				Constants._instance = new Constants(new SingletonEnforcer());
			}
			return(Constants._instance);
		}
		//SETS
		public function set scale(width:Number):void
		{
			this._scale = width/STAGE_WIDTH;
		}
		public function set scaleY(height:Number):void
		{
			this._scaleY = height/STAGE_HEIGHT;
		}
		
		public function set realWidth(w:uint):void
		{
			this._realWidth = w;
		}
		public function set realHeight(h:uint):void
		{
			this._realHeight = h;
		}
		public function set isReady(flag:Boolean):void
		{
			this._isReady = flag;
		}
		//GETS
		public function get scale():Number
		{
			return(this._scale);
		}
		public function get scaleY():Number
		{
			return(this._scaleY);
		}
		public function get realWidth():uint
		{
			return(this._realWidth);
		}
		public function get realHeight():uint
		{
			return(this._realHeight);
		}
		public function get isReady():Boolean
		{
			return(this._isReady);
		}
	}
}
class SingletonEnforcer {}