package com.tarambola.model
{
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.tarambola.ErrorDisplay;
	import com.tarambola.controller.NavEvents;
	import com.tarambola.model.Classes.Constants;
	import com.tarambola.model.Classes.ScreensaverModel;
	import com.tarambola.model.Classes.URLService;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.utils.AssetManager;

	public class Model extends starling.events.EventDispatcher
	{
		private var _assets:AssetManager;
		private var _path:File;
		private var _imgPath:File;
		private var _loader:BulkLoader;
		private var _configXML:XML;
		private var _service:URLService;
		private var _dataXml:XML;
		
		//MODELS
		private var _screensaver:ScreensaverModel;


		public function Model()
		{
			this._path = File.applicationDirectory.resolvePath("files");
			this._imgPath = File.applicationDirectory.resolvePath("arq").resolvePath("img");
			this._loader = new BulkLoader("main");	
			this._screensaver = new ScreensaverModel();
			this._service = new URLService();
		}
		public function init():void
		{
			this._assets = new AssetManager(Starling.current.contentScaleFactor);
			this._assets.verbose= Capabilities.isDebugger;
			this.loadXML();
		}
		//****** INIT HANDLERS ******//
		private function loadXML():void
		{
			var file:File = File.applicationDirectory.resolvePath("arq").resolvePath("xml");
			
			this._loader.add(this._path.resolvePath("config").resolvePath("config.xml").url, {type:"xml", id:"config"});
			
			this._loader.addEventListener(BulkProgressEvent.COMPLETE, parseXML);
			this._loader.start();
		}
		private function parseXML(evt:BulkProgressEvent):void
		{
			this._loader.removeEventListener(BulkProgressEvent.COMPLETE, parseXML);
			
			
			this._configXML = this._loader.getXML("config");
			
			
			this.loadAssets();
		}
		private function loadAssets():void
		{
			//******** AUDIO
			//******** TEXTURES ATLAS
			this._assets.enqueue(this._path.resolvePath("sprites").resolvePath("assets.png"));
			this._assets.enqueue(this._path.resolvePath("sprites").resolvePath("assets.xml"));
			//******** IMAGES
			this._assets.enqueue(this._path.resolvePath("images").resolvePath("background.png"));
			//******* PARTICLES
			//******* FONTS
			this._assets.enqueue(this._path.resolvePath("fonts").resolvePath("font1.png"));
			this._assets.enqueue(this._path.resolvePath("fonts").resolvePath("font2.png"));
			
			this._assets.loadQueue( onProgress);
		}
		private function loadImages():void
		{
			this._loader.add(this._path.resolvePath("images").resolvePath("logo_slot.png").url, {type:BulkLoader.TYPE_IMAGE, id:"logo_slot.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("corner.png").url, {type:BulkLoader.TYPE_IMAGE, id:"corner.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("qrcode.png").url, {type:BulkLoader.TYPE_IMAGE, id:"qrcode.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("logo_cmp.png").url, {type:BulkLoader.TYPE_IMAGE, id:"logo_cmp.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("slot_layer.png").url, {type:BulkLoader.TYPE_IMAGE, id:"slot_layer.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("layer_loose.png").url, {type:BulkLoader.TYPE_IMAGE, id:"layer_loose.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("glow.png").url, {type:BulkLoader.TYPE_IMAGE, id:"glow.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("bad_luck.png").url, {type:BulkLoader.TYPE_IMAGE, id:"bad_luck.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("congrats.png").url, {type:BulkLoader.TYPE_IMAGE, id:"congrats.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("label1.png").url, {type:BulkLoader.TYPE_IMAGE, id:"label1.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("label2.png").url, {type:BulkLoader.TYPE_IMAGE, id:"label2.png"});
			this._loader.add(this._path.resolvePath("images").resolvePath("label3.png").url, {type:BulkLoader.TYPE_IMAGE, id:"label3.png"});
			for(var i:uint=1; i<6; i++)
			{
				this._loader.add(this._path.resolvePath("images").resolvePath(i.toString()+".png").url, {type:BulkLoader.TYPE_IMAGE, id:i.toString()+".png"});
			}
			try{
				this._loader.add(this._imgPath.resolvePath("user_default.jpg").url, {type:BulkLoader.TYPE_IMAGE, id:"user_default"});
				}
				catch(err:Error){
					ErrorDisplay.getInstance().showError("Ficheiro 'user_default.jpg' não encontrado!");
				}
			this._loader.addEventListener(BulkProgressEvent.COMPLETE, onCompleteLoader);
			this._loader.start();
		}
		//*************
		//************* LISTENERS 
		private function onProgress(ratio:Number):void
		{
			if(ratio == 1.0)
				this.loadImages();
		}
		protected function onCompleteLoader(event:flash.events.Event):void
		{
			this._loader.removeEventListener(BulkProgressEvent.COMPLETE, onCompleteLoader);
			//this.dispatchEvent(new starling.events.Event("ALL.LOADED"));
			this.getUniqueId();
		}
		
		private function getQRCode(event:starling.events.Event):void
		{
			NavEvents.getInstance().removeEventListener("SERVICE.UNIQUEID.COMPLETE", getQRCode);
			
			var xml:XML = new XML(event.data.data);
			Constants.getInstance().actUniqueId = xml.unique_id;
			
			this._loader.addEventListener(BulkProgressEvent.COMPLETE, onCompleteService);
			var serverUrl: String = "https://chart.googleapis.com/chart?chs=290x290&cht=qr&chl="
					+ this.getServerUrl() + "/index.php" + "?id=" + xml.unique_id
			this._loader.add(serverUrl, {type:BulkLoader.TYPE_IMAGE, id:"qrcode"});
			this._loader.start();
		}
		
		protected function onCompleteService(event:flash.events.Event):void
		{
			this.dispatchEvent(new starling.events.Event("ALL.LOADED"));
		}
		//************
		//************ PUBLIC METHODS
		public function getUniqueId():void
		{
			this._loader.remove("qrcode");
			NavEvents.getInstance().addEventListener("SERVICE.UNIQUEID.COMPLETE", getQRCode);
			this._service.getUniqueId();
		}
		public function get asset():AssetManager
		{
			return(this._assets);
		}
		public function getImage(name:String):Bitmap
		{
			return(this._loader.getBitmap(name));
		}
		public function getTrad(name:String, lang:String):String
		{
			return(this._configXML.trad.child(name).child(lang));
		}

		public function getServerUrl():String {
			return(this._configXML.server_link);
		}

		public function getSocketPort(): int {
			return _configXML.socketPort;
		}

		public function getProbabilities():Number
		{
			return(Number(this._configXML.probabilities));
		}
		public function getRenewQRCode():Boolean
		{
			var r:Number = Number(this._configXML.renew_qrcode);
			if(r==0)
				return(false);
			else
				return(true);
		}
		public function getRenewTime():Number
		{
			return(Number(this._configXML.renew_time));
		}
		public function getColorBg():Number
		{
			return(Number(this._configXML.color_bg));
		}
		public function get screensaverModel():ScreensaverModel
		{
			return(this._screensaver);
		}
		public function getUserName():String
		{
			return(this._loader.getXML("userXML").child("nome"));
		}
		public function getUserAttempts():uint
		{
			return(uint(this._loader.getXML("userXML").child("attempts")));
		}
		public function getMaxPrize():uint
		{
			return(uint(this._dataXml.child("prizes").child("max_prize")));
		}
		public function getActPrize():uint
		{
			return(uint(this._dataXml.child("prizes").child("act_prizes")));
		}
		public function getLastPrize():uint
		{
			return(uint(this._dataXml.child("prizes").child("last_prize")));
		}
		public function getConnectMSG():Vector.<String>
		{
			var msg:Vector.<String> = new Vector.<String>;
			msg[0] = this._dataXml.child("connect_msg").child("msg_1").toString();
			msg[1] = this._dataXml.child("connect_msg").child("msg_2").toString();
			msg[2] = this._dataXml.child("connect_msg").child("msg_3").toString();
			return(msg);
		}
		public function getSlotMSG():Vector.<String>
		{
			var msg:Vector.<String> = new Vector.<String>;
			msg[0] = this._dataXml.child("slot_msg").child("msg_1").toString();
			msg[1] = this._dataXml.child("slot_msg").child("msg_2").toString();
			return(msg);
		}
		public function getLooseMSG():Vector.<String>
		{
			var msg:Vector.<String> = new Vector.<String>;
			msg[0] = this._dataXml.child("loose_msg").child("msg_1").toString();
			msg[1] = this._dataXml.child("loose_msg").child("msg_2").toString();
			msg[2] = this._dataXml.child("loose_msg").child("msg_3").toString();
			msg[3] = this._dataXml.child("loose_msg").child("msg_4").toString();
			msg[4] = this._dataXml.child("loose_msg").child("msg_5").toString();
			return(msg);
		}
		public function getAwardMSG():Vector.<String>
		{
			var msg:Vector.<String> = new Vector.<String>;
			msg[0] = this._dataXml.child("win_msg").child("msg_1").toString();
			msg[1] = this._dataXml.child("win_msg").child("msg_2").toString();
			return(msg);
		}		
		public function getUserInfo(id:uint):void
		{
			this._loader.addEventListener(BulkProgressEvent.COMPLETE, onCompleteUser);
			this._loader.remove("userXML");
			this._loader.add(this.getServerUrl()+"/funcionalidades/webservice.html?id="+id.toString(), {type:"xml", id:"userXML"});
			this._loader.start();
		}
		public function set dataXML(xml:XML):void
		{
			this._dataXml = xml;
		}
		protected function onCompleteUser(event:flash.events.Event):void
		{
			this._loader.removeEventListener(BulkProgressEvent.COMPLETE, onCompleteUser);
		}
	}
}