package gh.element.loader
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author GH
	 */
	public class ClassLoader extends ElementLoader implements ILoad
	{
		private var _cl:Class;
		
		public function ClassLoader(cl:Class) 
		{
			super();
			this._cl = cl;
		}
		override public function load(context:LoaderContext = null):void
		{
			this._loader.loadBytes(new _cl(), context);
			super.load(context);
		}
	}

}