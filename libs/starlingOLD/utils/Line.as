/**
 * Class Line
 * @author Leandro Barreto 2012
 * @version 1.0
 **/

package starling.utils
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Line extends Sprite
	{
		private var baseQuad:Quad;
		private var _thickness:Number = 1;
		private var _color:uint = 0x000000;
		
		public function Line(_x:Number=0, _y:Number=0, thickness:Number=1, color:uint=0x000000)
		{
			this._thickness = thickness;
			this._color = color;
			baseQuad = new Quad(1, thickness, color);
			baseQuad.x=_x;
			baseQuad.y=_y;
			addChild(baseQuad);
		}
		
		public function lineTo(toX:int, toY:int):void
		{
			var toX2:int = toX-baseQuad.x;
			var toY2:int = toY-baseQuad.y;
			baseQuad.width = Math.round(Math.sqrt((toX2*toX2)+(toY2*toY2)));
			baseQuad.rotation = Math.atan2(toY2, toX2);
		}
		
		public function set thickness(t:Number):void
		{
			var currentRotation:Number = baseQuad.rotation;
			baseQuad.rotation = 0;
			baseQuad.height = _thickness = t;
			baseQuad.rotation = currentRotation;
		}
		
		public function get thickness():Number
		{
			return _thickness;
		}
		
		public function set color(c:uint):void
		{
			baseQuad.color = _color = c;
		}
		
		public function get color():uint
		{
			return _color;
		}
	}
}