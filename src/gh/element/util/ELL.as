package gh.element.util  
{
	public class ELL
	{
		public static const isPublish:Boolean = false;
		
		//public static const DialogIDE_UI_WarnningBox:String = "DialogIDE_UI,WarnningBox";
		public static const UI_UILayer:String = "UI,UILayer";
		public static const UI_Loading:String = "UI,Loading";
		
		private var _loadList:Vector.<Vector.<String>>;
		public function ELL():void
		{
			this.init();
		} 
		private function init():void
		{
			_loadList = new Vector.<Vector.<String>>();

			_loadList.push(Vector.<String>(["UI", "ui/UI.swf"]));
		}

		public function get loadList():Vector.<Vector.<String>> { return _loadList.concat(); }
	}
}
