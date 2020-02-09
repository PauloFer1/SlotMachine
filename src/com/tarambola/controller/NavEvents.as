package com.tarambola.controller
{
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class NavEvents extends EventDispatcher
	{
		static private var _instance:NavEvents;
		
		private var _type:uint;
		private var _name:String;
		
		public function NavEvents(SingletonEnforcer:SingletonEnforcer)
		{
		}
		public static function getInstance():NavEvents
		{
			if(NavEvents._instance == null)
			{
				NavEvents._instance = new NavEvents(new SingletonEnforcer());
			}
			return(NavEvents._instance);
		}
		// ********* METHODS
		public function dispatchCustomNavEvent(event:Event):void
		{
			return(super.dispatchEvent(event));
		}
		public function dispatchCustomEvent(event:String, name:String, data:Object = null):void
		{
			this._name = name;
			return(super.dispatchEventWith(event, false, data));
		}
		//******** GETS
		public function get type():uint
		{
			return(this._type);
		}
		public function get name():String
		{
			return(this._name);
		}
		//******* SETS
		public function set type(type:uint):void
		{
			this._type = type;
		}
		public function set name(name:String):void
		{
			this._name = name;
		}
	}
}
class SingletonEnforcer {}