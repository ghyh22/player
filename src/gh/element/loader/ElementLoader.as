package gh.element.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author GH
	 */
	public class ElementLoader extends EventDispatcher implements ILoad
	{
		protected var _loader:Loader;
		
		public function ElementLoader() 
		{
			this._loader = new Loader();
		}
		
		public function load(context:LoaderContext = null):void
		{
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedEvent);
		}
		public function stop():void
		{
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedEvent);
		}
		private function loadedEvent(eve:Event):void
		{
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedEvent);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get domain():ApplicationDomain
		{
			return this._loader.contentLoaderInfo.applicationDomain;
		}
	}

}