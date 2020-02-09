package starling.extensions.video
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetDataEvent;
	import flash.events.NetStatusEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class StarlingVideo extends Sprite
	{
		//Native
		private var video:Video;
		private var bmd:BitmapData;
		private var ns:NetStream;
		private var nc:NetConnection;
		private var metadata:Object;
		
		//Starling
		private var image:Image;
		
		//Configs
		private var matrix:Matrix;
		private var _mirror:Boolean = false;
		private var _rectangle:Rectangle;
		private var _downSample:Number = 1;
		
		//CONTROLLS
		private var _path:String;
		private var firstPlay:uint=1;
		private var duration:Number=0;
		public var seconds:uint;
		public var minutes:uint; 
		public var percent:Number; 

		
		public function StarlingVideo(path:String)
		{
			super();
			this._path = path;
		}
		public function init(screenRect:Rectangle, fps:uint = 24, downSample:Number = 1, rotate:Boolean = false):void
		{
			this.nc = new NetConnection();
			this.nc.connect(null);
			this.ns = new NetStream(nc);
			this.ns.client = {};
			this.ns.client.onMetaData = onMetaData;
			this.video = new Video();
			
			this._downSample = downSample;
			this._rectangle = screenRect;
			this.matrix = new Matrix();
			this.matrix.scale(downSample, downSample);
			
			this.setVideo();
		/*	if (_mirror)
			{
				matrix.a *= -1;
				matrix.tx = (matrix.tx == 0) ? screenRect.width : 0;
			}
			
			if (rotate)
			{
				matrix.rotate(Math.PI/2);
			}*/
		}
		//*********** METHODS ***********//
		public function setVideo():void
		{
			this.ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this.ns.play(File.applicationDirectory.resolvePath("arq").resolvePath("fich").resolvePath(this._path).url);
			this.ns.addEventListener(NetStatusEvent.NET_STATUS, loop);
			//this.ns.addEventListener(NetDataEvent.MEDIA_TYPE_DATA, onMetaData);
			this.ns.pause();
			
			
			if(this.video)
			{
				this.video.removeEventListener(Event.ENTER_FRAME, onVideoUpdate);
			}
			
			
			
			
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			//this._play();
		}
		public function shutdown():void
		{
			video.removeEventListener(Event.ENTER_FRAME, onVideoUpdate);
		}
		//******* HANDLERS ******//
		private function update(evt:Event):void
		{
			var scds:uint=this.ns.time % 60;
			var mnts:uint=(this.ns.time/60) % 60;
			
			this.seconds = scds;
			this.minutes = mnts;
			this.percent = this.ns.time / this.duration ;
			
		}
		private function onMetaData(obj:Object):void
		{
			var h:uint;
			var w:Number;
			this.metadata=obj;
			for(var o:* in  obj)
			{
				if(o=="duration")
					this.duration=obj[o];
				if(o=="height")
					h = obj[o];
				if(o=="width")
				{
					w = obj[o];
				}
			}
			if(this.firstPlay==1)
			{
				this.firstPlay=0;
				var r:Number = 800/w;		
				this.video = new Video(800,h*r);//this._rectangle.width, this._rectangle.height);
				//this.pivotX = this.video.width/2;
				//this.pivotY = this.video.height/2;
				this.video.attachNetStream(this.ns);
				
				
				this._rectangle = new Rectangle(this.video.width, this.video.height);
				this.bmd = new BitmapData(this.video.width * this._downSample, this.video.height * this._downSample);
				
				var texture:starling.textures.Texture = starling.textures.Texture.fromBitmapData(bmd, false, false, this._downSample);
				this.image = new Image(texture);
				this.image.smoothing = TextureSmoothing.TRILINEAR;
				
				addChild(this.image);
				
				this.video.addEventListener(Event.ENTER_FRAME, onVideoUpdate);
				this.dispatchEventWith("REARRANGE");
			}

		}
		private function onVideoUpdate(event:*):void
		{
			bmd.draw(this.video, matrix);
			flash.display3D.textures.Texture(image.texture.base).uploadFromBitmapData(bmd);
		}
		protected function loop(event:NetStatusEvent):void
		{
			if(event.info.code == "NetStream.Play.Stop")
			{
				this.ns.seek(0);
				this.ns.pause();
				this.dispatchEventWith("FINISH");
			}
		}
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			trace("***** ASSYNC ERROR ****");	
		}
		
		//************ PUBLIC METHODS ***********//
		public function _play():void
		{
			this.ns.seek(0);
			this.ns.resume();
		}
		public function _playExt():void
		{
			this.ns.seek(0);
			this.ns.resume();
		}
		public function _stop():void
		{
			this.ns.pause();
		}
		public function _resume():void
		{
			this.ns.resume();
		}
		public function _seek(seek:uint, barWidth:uint):void
		{
			this.ns.seek((seek*this.duration)/barWidth);
		}
	}
}