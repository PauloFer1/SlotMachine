package com.tarambola.model.Classes
{
	import com.tarambola.ErrorDisplay;
	import com.tarambola.HashMap;

	public class StringLang
	{
		private var string:HashMap;
		
		public function StringLang(lang:String="", string:String="")
		{
			this.string = new HashMap();
			if(lang!="" && string!="")
				this.add(lang, string);
			/*else
				ErrorDisplay.getInstance().showError("CONSTRUCTER StringLang WITHOUT ARGUMENTS!");*/
		}
		public function add(lang:String, string:String):void
		{
			this.string.put(lang, string);
		}
		public function getString(lang:String):String
		{
			return(this.string.get(lang) as String);
		}
	}
}