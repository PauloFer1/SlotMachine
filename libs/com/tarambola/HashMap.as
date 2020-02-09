package com.tarambola 
{
	public class HashMap
	{
		    
		    public var keys:Array; 
		    public var values:Array; 
		    //
		    public function HashMap(source:Array=null):void
		    {
			        super();
			        this.keys = new Array();
			        this.values = new Array();
			        this.populate(source);
		    }
		    public function populate(source:Array):void
		    {
			        if (source)
			        {
				            for (var i:Object in source)
				            {
					                this.put(i, source[i]);
				            }
			        }
		    }
		
		    public function containsKey(key:Object):Boolean
		    {
			        return (this.findKey(key) > -1);
		    }
		    public function containsValue(value:Object):Boolean
		    {
			        return (this.findValue(value) > -1);
		    }
		    public function getKeys():Array
		    {
			        return (this.keys.slice());
		    }
		    public function getValues():Array
		    {
			        return (this.values.slice());
		    }
		    public function get(key:Object):Object
		    {
			        return (values[this.findKey(key)]);
		    }
		    public function put(key:Object, value:Object):Object
		    {
			        var oldKey:Object;
			        var theKey:Object = this.findKey(key);
			        if (theKey < 0)
			        {
				            this.keys.push(key);
				            this.values.push(value);
			        }
			        else
			        {
				            oldKey = values[theKey];
				            this.values[theKey] = value;
			        }
			        return (oldKey);
		    }
		    public function putAll(map:HashMap):void
		    {
			        var theValues:Array = map.getValues();
			        var theKeys:Array = map.getKeys();
			        var max:int = keys.length;
			        for (var i:uint = 0; i < max; i = i - 1)
			        {
				            this.put(theKeys[i], theValues[i]);
			        }
		    }
		    public function clear():void
		    {
			        this.keys = new Array();
			        this.values = new Array();
		    }
		    public function remove(key:Object):Object
		    {
			        var theKey:Object = this.findKey(key);
			        if (theKey > -1)
			        {
				            var theValue:Object = this.values[theKey];
				            this.values.splice(theKey, 1);
				            this.keys.splice(theKey, 1);
				            return (theValue);
			        }
				return null;
		    }
		    public function size():int
		    {
			        return (this.keys.length);
		    }
		    public function isEmpty():Boolean
		    {
			        return (this.size() < 1);
		    }
		    public function findKey(key:Object):int
		    {
			        var index:int = this.keys.length;
			        while(this.keys[--index] !== key && index > -1)
			        {
			        }
			        return(index);
		    }
		    public function findValue(value:Object):int
		    {
			        var index:int = this.values.length;
			        while(this.values[--index] !== value && index > -1)
			        {
			        }
			        return (index);
		    }
	}
}