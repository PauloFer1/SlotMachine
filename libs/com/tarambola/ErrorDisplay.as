package com.tarambola
{
	import com.greensock.TweenLite;
	import com.tarambola.Draw;
	import com.tarambola.Layout;
	import com.tarambola.TextStyle;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;

	
	public class ErrorDisplay
	{
		
		static private var _instance:ErrorDisplay;
		
		private var _stage:Stage;
		
		private var _topLayer:Sprite;
		private var _container:Sprite;
		private var _message:TextField;
		private var _bg:Shape;
		private var _nErrors:uint=0;
		
		
		public function ErrorDisplay(SingletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():ErrorDisplay
		{
			if(ErrorDisplay._instance == null)
			{
				ErrorDisplay._instance = new ErrorDisplay(new SingletonEnforcer());
			}
			return(ErrorDisplay._instance);
		}
		public function init(stage:Stage, top:Sprite):void
		{
			this._stage = stage;
			this._topLayer = top;
			this._container = new Sprite();
			this._container.alpha=0;
		}
		//********************* METHODS *****************//
		public function showError(msg:String):void
		{
			this._nErrors++;
			var bg:Shape;
			var message:TextField;
			var container:Sprite = new Sprite();
			container.alpha=0;
			bg = Draw.dRect(this._stage.fullScreenWidth/1.5, 400, 0x000000);
			bg.alpha = 0.5;
			container.addChild(bg);
			
			message = new TextStyle("titulo", {x:0, y:10, multiline:true,wordWrap:true, htmlText:msg, type:TextFieldType.DYNAMIC, selectable:false, embedFonts:false, textAlign:TextFormatAlign.CENTER}).getText();
			message.width=bg.width - 20;
			message.height = message.textHeight + 20;
			bg.height = message.height + 20;
			
			container.addChild(message);
			this._topLayer.addChild(new Layout(container, this._stage, Layout.TOP_CENTER, false, 1, (bg.height+5)*(this._nErrors-1)).Obj);
			
			TweenLite.to(container, 0.5, {alpha:1, onComplete: removeMessage, onCompleteParams: [container]});
		}
		public function buildContinuos():void
		{
			this._container = new Sprite();
			this._bg = Draw.dRect(this._stage.fullScreenWidth/1.5, 400, 0x000000);
			this._bg.alpha = 0.5;
			this._container.addChild(this._bg);
			
			this._message = new TextStyle("titulo", {x:0, y:10, multiline:true,wordWrap:true, htmlText:"", type:TextFieldType.DYNAMIC, selectable:false, embedFonts:false, textAlign:TextFormatAlign.CENTER}).getText();
			this._message.width=this._bg.width - 20;
			this._message.height = this._message.textHeight + 20;
			this._bg.height = this._message.height + 20;
			
			this._container.addChild(this._message);
			
			this._topLayer.addChild(new Layout(this._container, this._stage, Layout.TOP_CENTER, false, 1, 10).Obj);
		}
		public function showContinuos(msg:String):void
		{
			this._message.text = msg;
		}
		public function removeContinuos():void
		{
			this._container.removeChild(this._message);
			this._container.removeChild(this._bg);
		}
		private function removeMessage(container:Sprite):void
		{
			TweenLite.to(container, 0.5, {alpha:0, onComplete:removeContainer, onCompleteParams:[container], delay:2.5});
		}
		private function removeContainer(container:Sprite):void
		{
			this._topLayer.removeChild(container);
			this._nErrors--;
		}
	}
}
class SingletonEnforcer {}