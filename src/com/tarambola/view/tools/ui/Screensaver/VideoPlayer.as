package com.tarambola.view.tools.ui.Screensaver
{
	
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetDataEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	
	public class VideoPlayer extends Sprite
	{
		private var _stage:Stage;
		
		private var ns:NetStream;
		private var isPlay:uint=0;
		private var isMute:uint=0;
		private var metadata:Object;
		private var duration:Number=0;
		private var firstPlay:uint=1;
		
		public function VideoPlayer(caminho:String)
		{
			var video:Video;
			var ratio:uint=0;
			var id:uint=0;
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			this.ns = new NetStream(nc);
			this.ns.client = {};
			this.ns.client.onMetaData = onmetadata;
			var vid:Video = new Video();
					
			
			//ns.client={onMetaData:function(obj:Object):void{} }
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			//******************** APP ROMANO MEDIEVAL
			ns.play(caminho);
			//******************** APP PRÉ HISTORIA
			//ns.play(File.applicationDirectory.resolvePath("files").resolvePath("videos2").resolvePath(caminho).url);
			ns.addEventListener(NetStatusEvent.NET_STATUS, loop);
			ns.addEventListener(NetDataEvent.MEDIA_TYPE_DATA, onmetadata);
			ns.pause();
			
			vid.attachNetStream(ns);
			vid.width = 1920;
			vid.height = 1080;
			addChild(vid);
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		protected function seekBar(event:MouseEvent):void
		{
		}
		private function onmetadata(obj:Object):void
		{
			this.metadata=obj;
			for(var o:* in  obj)
			{
				if(o=="duration")
					this.duration=obj[o];
			}
			if(this.firstPlay==1)
			{
				this._playExt();
				this.firstPlay=0;
			}
		}
		protected function loop(event:NetStatusEvent):void
		{
			if(event.info.code == "NetStream.Play.Stop")
			{
				this.isPlay=0;
				this.ns.seek(0);
				this.ns.pause();
				this.ns.resume();
			}
		}
		private function update(evt:Event):void
		{
			var scds:uint=this.ns.time % 60;
			var mnts:uint=(this.ns.time/60) % 60;
			var ss:String;
			if(scds<10)
				ss="0" + scds.toString();
			else
				ss=scds.toString();
		}
		protected function pauseHandler(event:MouseEvent):void
		{
			this.ns.pause();
			
		}
		
		protected function playHandler(event:MouseEvent):void
		{
			if(this.isPlay==0)
			{
				this.ns.resume();
				this.isPlay=1;
			}
			else
			{
				this.ns.pause();
				this.isPlay=0;
			}
		}
		protected function muteHandler(event:MouseEvent):void
		{
			var s:SoundTransform;
			if(this.isMute==0)
			{
				s = new SoundTransform(0);
				this.ns.soundTransform=s;
				this.isMute=1;
			}
			else
			{
				s = new SoundTransform(1);
				this.ns.soundTransform=s;
				this.isMute=0;
			}
		}
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			
		}
		public function _play():void
		{
			this.ns.seek(0);
			this.ns.resume();
		}
		public function _playExt():void
		{
			this.ns.seek(0);
			this.ns.resume();
			this.isPlay=1;
		}
		public function _stop():void
		{
			this.ns.pause();
		}
		public function get _isPlay():uint
		{
			return(this.isPlay);
		}
		
	}
	
}