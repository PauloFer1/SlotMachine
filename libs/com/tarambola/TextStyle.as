package com.tarambola 
{
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextStyle
	{
		
		private var textF:TextField;
		private var textField:TextField;

		private var styles:Array; //objectos contendo o estilo com id name (ex: name: titulo1, font: Arial, size: 14)
				
		public function TextStyle(name:String, args:Object = null, tf:TextField=null)
		{
			if(tf!=null)
				this.textField=tf;
			else
				this.textField = new TextField();
			init( new Array({name:"titulo",font:"Arial",size:"16",color:"0xffffff"},{name:"titulo2",font:"DaxWide-Regular",size:"28",color:"0xFFB000"}, {name:"texto", font:"Avant Garde Book BT", color:"0xffffff", size:"55", leading:2, bold:false}, {name:"texto2", font:"Myriad Pro", color:"0x1F1F1E", size:"14", leading:2, bold:false}) ) ;
			if(args!=null && name!=null)
			{
				this.textF = setText(name, args);
			}
		}
		public function init(styles:Array):void
		{
			this.styles = styles;
		}
		public function getText():TextField
		{
			return(this.textF);
		}
		
		public function setText(name:String, args:Object = null):TextField
		{
			
			textField.embedFonts = true;
			//textField.mouseEnabled = false;
			textField.multiline = false;
			textField.wordWrap = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			//textField.autoSize = TextFieldAutoSize.CENTER;
			
			var format : TextFormat = setFormat(this.getFormat(name));
			for (var arg1:String in args)
			{
				if (arg1 == "textAlign")
				{
					format.align = args[arg1];
					
				}
			}
			if(format!=null)
				textField.defaultTextFormat = format;
			
			for (var arg:String in args)
			{
				if (arg == "textAlign")
				{
					format.align = args[arg];
					
				}
				else if (textField.hasOwnProperty(arg))
				{
					textField[arg] = args[arg];
				}
			}
			return (textField);
		}
		
		private function setFormat(style:Object):TextFormat
		{
			if(style!=null)
			{
				var format : TextFormat = new TextFormat();
				for (var sty: String in style)
				{
					if(sty!="name")
						format[sty] = style[sty];
				}
				return format;
			}
			else
				return null;
		}
		
		private function getFormat(name:String):Object
		{
			var a :Array = this.styles;
			for(var i:int =0; i<a.length; i++)
			{
				if(a[i].name== name)
				{
					return(a[i]);
				}
			}
			return(null);
		}
		
		private function setStyles(styles:Array):void
		{
			this.styles = styles;
		}
	}
}