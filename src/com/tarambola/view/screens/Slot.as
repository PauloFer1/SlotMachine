package com.tarambola.view.screens
{
	import com.tarambola.controller.NavEvents;
	import com.tarambola.model.Classes.Arq;
	import com.tarambola.model.Classes.Constants;
	import com.tarambola.model.Classes.Fonts;
	import com.tarambola.view.tools.objects.Machine;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class Slot extends Screen
	{
		private var _title:TextField;
		private var _subTitle:TextField;
		private var _machine:Machine;
		private var _label1:Image;
		private var _label2:Image;
		
		public function Slot()
		{
			super();
			this.build();
		}
		private function build():void
		{
			this.alpha = 0;
			
			NavEvents.getInstance().addEventListener("ROLL.MACHINE", hideSubTitle);
			
			var font:BitmapFont;
			font = Fonts.getInstance().getFont(Constants.FONT_TITLE2);
			this._title = new TextField(1200, 400, ", É A TUA VEZ!", font.name, 56, 0xFFFFFF);
			this._title.hAlign = HAlign.CENTER;
			this._title.vAlign = VAlign.TOP;
			
			this._title.x = Starling.current.stage.stageWidth/2 - this._title.width/2;
			this._title.y = 294+50;
			
			this._subTitle = new TextField(1000, 400, "PRESS ROLL", font.name, 60, 0xFFFFFF);
			this._subTitle.hAlign = HAlign.CENTER;
			this._subTitle.vAlign = VAlign.TOP;
			
			this._subTitle.x = Starling.current.stage.stageWidth/2 - this._subTitle.width/2;
			this._subTitle.y = Starling.current.stage.stageHeight - this._subTitle.textBounds.height - 290+50;
			
			this._label1 = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("label1.png")));
			this._label2 = new Image(Texture.fromBitmap(Arq.getInstance().model.getImage("label3.png")));
			this._label1.x = Starling.current.stage.stageWidth/2 - this._label1.width/2;
			this._label2.x = Starling.current.stage.stageWidth/2 - this._label2.width/2;
			this._label1.y = this._title.y-28;
			this._label2.y = this._subTitle.y-25;
			
			this._machine = new Machine();
			
			this.addChild(this._label1);
			this.addChild(this._label2);
			
			this.addChild(this._title);
			this.addChild(this._subTitle);
			this.addChild(this._machine)
		}
		public override function init():void
		{
			this._subTitle.alpha=1;
			this._label2.alpha=1;
			this._title.text = Arq.getInstance().model.getUserName().toUpperCase()+", "+Arq.getInstance().model.getSlotMSG()[0];
			this._subTitle.text = Arq.getInstance().model.getSlotMSG()[1];
			this._label1.width = this._title.textBounds.width+100;
			this._label1.x = Starling.current.stage.stageWidth/2 - this._label1.width/2;
			this._label2.width = this._subTitle.textBounds.width+100;
			this._label2.x = Starling.current.stage.stageWidth/2 - this._label2.width/2;
			super.init();
		}
		private function hideSubTitle():void
		{
			this._subTitle.alpha=0;
			this._label2.alpha=0;
		}
		public function restart():void
		{
			this._machine.restart();
		}
	}
}