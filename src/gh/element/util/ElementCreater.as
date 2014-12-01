package gh.element.util
{
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author GH
	 */
	public class ElementCreater
	{
		private var _files:Vector.<String>;
		private var _domainList:Vector.<ApplicationDomain>;
		
		public function ElementCreater(loadManager:LoadManager) 
		{
			this._files = loadManager.files;
			this._domainList = loadManager.domainList;
		}
		/**
		 * 创建元素的元件
		 * @param	element 文件名_类名
		 * @return
		 */
		public function getElement(element:String):Object
		{
			var temp:Array = element.split(",");
			return this.getFileElement(temp[0], temp[1]);
		}
		/**
		 * 
		 * @param	file
		 * @param	element
		 * @return
		 */
		public function getFileElement(file:String, element:String):Object
		{
			var index:int = this._files.indexOf(file);
			var domain:ApplicationDomain = this._domainList[index];
			var cl:Class = domain.getDefinition(element) as Class;
			return new cl();
		}
	}

}