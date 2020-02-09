package com.tarambola.model.Classes
{
	import com.tarambola.controller.Controller;
	import com.tarambola.model.Model;

	public class Arq
	{
		static private var _instance:Arq;
		
		private var _model:Model;
		private var _controller:Controller
		
		public function Arq(SingletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():Arq
		{
			if(Arq._instance == null)
			{
				Arq._instance = new Arq(new SingletonEnforcer());
			}
			return(Arq._instance);
		}
		public function init(model:Model, controller:Controller):void
		{
			this._model = model;
			this._controller = controller;
		}
		
		public function get controller():Controller
		{
			return(this._controller);
		}
		public function get model():Model
		{
			return(this._model);
		}
	}
}
class SingletonEnforcer {}