package com.tarambola 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Birray
	{
		private var end1: Array;
		private var end2: Array;
		
		private var pos:int;
		
		private var _x:Number;
		private var _y:Number; 
		
		public function Birray(...args)
		{
			this.end1 = new Array();
			this.end2 = new Array();
							
			for( var i:int =0; i<args.length; i++)
			{
				trace("arg " + args[i]);
				var arg:Point = new Point(args[i]);
				this.end1.push(arg.x);
				this.end2.push(arg.y);
			}
		}
		public function getX(pos:int):Number
		{
			return(end1[pos]);
		}
		public function getY(pos:int):Number
		{
			return(end2[pos]);
		}
		
/*		private function splitArg(subArg:Point):Array
		{
				
		}*/
	}
}