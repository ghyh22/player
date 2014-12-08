package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @author gonghao
	 * @email $(DefaultEmail)
	 * @date 2014/11/24 10:20
	 **/
	public class LOG 
	{
		
		public function LOG() 
		{
			
		}
		
		private static var count:uint = 0;
		private static var text:TextField = new TextField();
		private static var stage:Sprite;
		private static var appStep:String = "";
		public static var appFlag:Boolean = false;
		public static function initLog(s:Sprite):void
		{
			text.width = 400;
			text.height = 200;
			text.border = true;
			text.background = true;
			stage = s;
		}
		
		public static function show(str:String, meg:String = null):void {
			var tmp:String = count.toString() + ": " + str;
			if (meg != null) {
				tmp += " : " + meg;
			}
			trace(tmp);
			text.appendText(tmp + "\n");
			text.scrollV = text.maxScrollV;
			count ++;
		}
		
		public static function addStep(str:String):void {
			appStep += str + "\n";
			if (appFlag) show(str);
		}
		public static function showAppStep():void {
			text.appendText(appStep);
			text.scrollV = text.maxScrollV;
		}
		
		/**
		 * 显示隐藏
		 */
		public static function sd():void {
			if (stage.contains(text)) {
				stage.removeChild(text);
			}else {
				stage.addChild(text);
			}
		}
	}

}