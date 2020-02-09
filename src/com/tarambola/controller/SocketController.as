package com.tarambola.controller
{
	import com.tarambola.model.Classes.Constants;
	import com.tarambola.model.Model;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.TimerEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class SocketController
	{
		private var model: Model;
		private var _server:ServerSocket;
		private var _socket:Socket;
		private var _timer:Timer;
		private var _time:uint=30;
		private var _socketWritter:Socket;
		
		public function SocketController(model: Model) {
			this.model = model;
		}

		function initSocket(): void {
			this._server = new ServerSocket();
			this._server.addEventListener(Event.CONNECT, onConnect);
			this._server.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			this._server.addEventListener(Event.CLOSE, onClose);
			this._server.bind(model.getSocketPort());
			this._server.listen();

			this._timer = new Timer(1000, 5);
			this._timer.addEventListener(TimerEvent.TIMER, writeInSocket);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, closeSocket);
		}
		
		protected function onClose(event:Event):void
		{
			trace("closeSocket");
		}
		private function onConnect(e:ServerSocketConnectEvent):void
		{
			this._socket = e.socket;
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
		}
		private function onData(event:ProgressEvent):void 
		{ 
			try
			{
				this._socketWritter = event.target as Socket;
				var bytes:ByteArray = new ByteArray();
				this._socketWritter.readBytes(bytes);
				var request:String = "" + bytes;
				var filePath:String = request.substring(4, request.indexOf("HTTP/") - 1);
				var urls:Array = filePath.split("/");
				
				if(urls[1]==Constants.getInstance().actUniqueId)
				{
					if(urls[3]=="roll")
					{
						NavEvents.getInstance().dispatchCustomEvent("ROLL.MACHINE", "socket");//Machine
					}
					else
					{
						NavEvents.getInstance().dispatchCustomEvent("GOTO.SLOT", "socket", {id:urls[2]});//view
					}
					
					this._socketWritter.writeUTFBytes('1');
				}
				else
				{
					this._socketWritter.writeUTFBytes('0');
				}
				
				this._socketWritter.flush();
				this._socketWritter.close();
			}
			catch (error:Error)
			{
				trace(error.message, "Error");
			}
		}
		protected function writeInSocket(event:TimerEvent):void
		{
			this._time--;
		}
		protected function closeSocket(event:TimerEvent):void
		{
			this._socketWritter.writeUTFBytes("Parabéns! Foi Vencedor!");
			this._socketWritter.writeUTFBytes("</h2></body></html>");
			this._socketWritter.flush();
			this._socketWritter.close();
		}
	}
}