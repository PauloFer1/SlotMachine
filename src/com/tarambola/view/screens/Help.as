package com.tarambola.view.screens
{
	import com.tarambola.Draw;
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.view.tools.ui.Screensaver.VideoPlayer;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import starling.core.Starling;
	
	public class Help extends Sprite
	{
		private var _image:Bitmap;
		private var _quad:Shape;
		private var _close:Bitmap;
		private var _closeCont:Sprite;
		private var _video:VideoPlayer;
		
		public function Help()
		{
			super();
			
			this.visible = false;
			
			this._quad = Draw.dRect(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0x004b8d);
			
			this._close = Arq.getInstance().model.getImage("close_btn");
			this._closeCont = new Sprite();
			this._closeCont.addChild(this._close);
			this._closeCont.y = 60;
			this._closeCont.x = Starling.current.stage.stageWidth - this._close.width - 98;
			
			this.addChild(this._quad);
			
			this._closeCont.buttonMode = true;
			this._closeCont.addEventListener(MouseEvent.CLICK, hide);
			
			this._video = new VideoPlayer(File.applicationDirectory.resolvePath("arq").resolvePath("fich").resolvePath("help.flv").url);
			this._video.x = Starling.current.stage.stageWidth/2 - this._video.width/2;
			this._video.y = 0;
			this.addChild(this._video);
			this.addChild(this._closeCont);
		}
		public function show():void
		{
			this.visible = true;
		}
		public function hide(event:MouseEvent=null):void
		{
			this.visible=false;
		}
	}
}