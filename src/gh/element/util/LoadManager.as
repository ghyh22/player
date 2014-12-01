package gh.element.util
{
	import gh.element.loader.ClassLoader;
	import gh.element.loader.ElementLoader;
	import gh.element.loader.SWFLoader;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author GH
	 */
	public class LoadManager extends EventDispatcher
	{
		private var _elementsLoadList:ELL;
		private var _files:Vector.<String>;
		private var _loadList:Vector.<ElementLoader>;
		private var _domainList:Vector.<ApplicationDomain>;
		private var _loadCounter:int;
		
		public function LoadManager(elementsLoadList:ELL) 
		{
			this._elementsLoadList = elementsLoadList;
			var temp:Vector.<Vector.<String>> = this._elementsLoadList.loadList;
			this._files = new Vector.<String>(temp.length);
			this._loadList = new Vector.<ElementLoader>(temp.length);
			this._domainList = new Vector.<ApplicationDomain>(temp.length);
			this._loadCounter = 0;
			this.init();
		}
		private function init():void
		{
			this.makeLoaderList();
		}
		private function makeLoaderList():void
		{
			var temp:Vector.<Vector.<String>> = this._elementsLoadList.loadList;
			for (var i:int = 0; i < temp.length; i ++)
			{
				var eLoader:ElementLoader;
				var type:String = temp[i][0];
				if (ELL.isPublish)
				{
					var cl:Class = ELL[type];
					eLoader = new ClassLoader(cl);
				}
				else
				{
					var url:String = temp[i][1];
					eLoader = new SWFLoader(url);
				}
				this._files[i] = type;
				this._loadList[i] = eLoader;
			}
		}
		public function load():void
		{
			this._loadCounter = 0;
			if (_files.length == 0) {
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			for (var i:int = 0; i < this._files.length; i ++)
			{
				var loader:ElementLoader= this._loadList[i];
				var context:LoaderContext = new LoaderContext();
				context.applicationDomain = new ApplicationDomain();
				loader.addEventListener(Event.COMPLETE, loadedEvent);
				loader.load(context);
			}
		}
		public function stop():void
		{
			for (var i:int = 0; i < this._files.length; i ++)
			{
				var loader:ElementLoader= this._loadList[i];
				loader.removeEventListener(Event.COMPLETE, loadedEvent);
				loader.stop();
			}
		}
		private function loadedEvent(eve:Event):void
		{
			var loader:ElementLoader = eve.currentTarget as ElementLoader;
			var index:int = this._loadList.indexOf(loader);
			this._domainList[index] = loader.domain;
			this._loadCounter ++;
			if (this._loadCounter == this._loadList.length)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function get loadRate():Number
		{
			return this._loadCounter / this._loadList.length;
		}
		
		public function get files():Vector.<String> { return _files.concat(); }
		
		public function get domainList():Vector.<ApplicationDomain> { return _domainList.concat(); }
		
	}

}