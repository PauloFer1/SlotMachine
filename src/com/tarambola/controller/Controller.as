package com.tarambola.controller
{
	import com.tarambola.model.Model;
	
	import com.tarambola.controller.SocketController;
	
	public class Controller
	{
		private var model:Model;
		private var _socketController:SocketController;
		
		public function Controller(model:Model)
		{
			this.model=model;
			this._socketController = new SocketController();	
		}
		public function init():void
		{
		}
	}
}