package gh.element.loader
{
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author GH
	 */
	public class SWFLoader extends ElementLoader implements ILoad
	{
		private var _url:URLRequest;
		
		public function SWFLoader(url:String) 
		{
			super();
			this._url = new URLRequest(url);
		}
		override public function load(context:LoaderContext = null):void
		{
			try {
				this._loader.load(this._url, context);
			}
			catch (e:SecurityError) {
				LOG.show("ELL Load Error:" + e.message);
			}
			
			super.load(context);
		}
	}

}