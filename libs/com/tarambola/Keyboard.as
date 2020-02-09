package com.tarambola {
	import com.greensock.TweenLite;
	import com.tarambola.Draw;
	import com.tarambola.TextStyle;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class Keyboard extends MovieClip{
		
		private var _form:Sprite;
		private var keys:Array;
		private var keysCont:Sprite;
		private var imgA:Array;
		private var wait:MovieClip;
		
		private var currentLetter:String="";
		
		public function Keyboard() 
		{
			this.keys= new Array();
			this.keysCont = new Sprite();
			this.createForm();
			this.createKeys();
		}

		private function createForm():void
		{
			addChild(this.keysCont);
		}
		private function createKeys():void {
			
			var w:Number = 63 + 5;
			
			// Numérico
			/*createKey(w*10, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"1"});
			createKey(w*11, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"2"});
			createKey(w*12, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"3"});
			
			createKey(w*10, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"4"});
			createKey(w*11, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"5"});
			createKey(w*12, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"6"});
			
			createKey(w*10, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"7"});
			createKey(w*11, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"8"});
			createKey(w*12, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"9"});
			
			createKey(w*11, w*3, {shape:"rectangle", width:80, height:80, ghost:false, letter:"0"});*/
			
			// 1 linha
			createKey(0, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"q"});
			createKey(w, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"w"});
			createKey(w*2, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"e"});
			createKey(w*3, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"r"});
			createKey(w*4, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"t"});
			createKey(w*5, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"y"});
			createKey(w*6, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"u"});
			createKey(w*7, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"i"});
			createKey(w*8, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"o"});
			createKey(w*9, 0, {shape:"rectangle", width:80, height:80, ghost:false, letter:"p"});
			
			// 2 linha
			createKey(0, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"a"});
			createKey(w, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"s"});
			createKey(w*2, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"d"});
			createKey(w*3, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"f"});
			createKey(w*4, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"g"});
			createKey(w*5, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"h"});
			createKey(w*6, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"j"});
			createKey(w*7, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"k"});
			createKey(w*8, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"l"});
			createKey(w*9, w, {shape:"rectangle", width:80, height:80, ghost:false, letter:"&"});
			
			// 3 linha
			
			createKey(0, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"z"});
			createKey(w, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"x"});
			createKey(w*2, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"c"});
			createKey(w*3, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"v"});
			createKey(w*4, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"b"});
			createKey(w*5, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"n"});
			createKey(w*6, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"m"});
			createKey(w*7, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:","});
			createKey(w*8, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"."});
			createKey(w*9, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"-"});
			
			//4 linha
			createSpace(w*10, 0);
			createKey(w*10, w*2, {shape:"rectangle", width:80, height:80, ghost:false, letter:"_"});
			createBackspace(w*10, w*1);
		//	createKey(w*7, w*3, {shape:"rectangle", width:80, height:80, ghost:false, letter:"@"});
		//	createSend(w*8, w*3);
		}
		
		private function createSpace(__x:Number, __y:Number):void
		{
			createKey(__x, __y, {shape:"rectangle", width:200, height:80, ghost:false, letter:" "});
		}
		private function createBackspace(__x:Number, __y:Number):void
		{
			var back:Key = getSpecialKey(__x, __y, {shape:"rectangle", width:200, height:80, ghost:false, letter:"<-"});
			back.addEventListener(MouseEvent.CLICK, deleteLetter);
		}
	/*	private function createSend(__x:Number, __y:Number):void
		{
			var enviar:Enviar = new Enviar();
			enviar.x=__x;
			enviar.y=__y;
			enviar.mouseChildren=false;
			this.keysCont.addChild(enviar);
			if(this._lang=="en")
				enviar.letra.text="SEND";
		}
		*/
		private function createKey(__x:Number, __y:Number, parameters:Object, backspace:Boolean = false):void
		{
			var key:Key = new Key();
			key.x=__x;
			key.y=__y;
			key.mouseChildren = false;
			key.letra.text=parameters.letter.toUpperCase();
			key.id=parameters.letter;
			this.keysCont.addChild(key);
			if (!parameters.ghost) 
			{
				this.keys.push(key);
				key.addEventListener(MouseEvent.CLICK, addLetter);
			}
		}
		private function getSpecialKey(__x:Number, __y:Number, parameters:Object, backspace:Boolean = false):Key
		{
			var key:Key = new Key();
			key.x=__x;
			key.y=__y;
			key.mouseChildren = false;
			key.letra.text=parameters.letter.toUpperCase();
			key.id=parameters.letter;
			this.keysCont.addChild(key);
			if (!parameters.ghost) 
			{
				this.keys.push(key);
			}
			return(key);
		}
		private function pressKey(ob:DisplayObject):void
		{
			TweenLite.to(ob, 0.2, {tint:0x27AAE1, onComplete:function():void{ TweenLite.to(ob, 0.6, {tint:0x666666 }); } });
		}
		private function addLetter(evt:MouseEvent):void
		{
				this.pressKey(evt.target.outline);
				this.pressKey(evt.target.letra);
				this.currentLetter=evt.target.letra.text;
				this.dispatchEvent(new Event("ADD_LETTER"));
		}
		private function deleteLetter(evt:MouseEvent):void
		{
			this.pressKey(evt.target.outline);
			this.pressKey(evt.target.letra);
			this.dispatchEvent(new Event("REMOVE_LETTER"));
		}
		public function getCurrentLetter():String
		{
			return(this.currentLetter);
		}
	}
	
}
