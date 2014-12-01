package gh.element.loader
{
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author GH
	 */
	public interface ILoad 
	{
		function load(content:LoaderContext = null):void;
		function stop():void;
	}
	
}