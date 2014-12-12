package  {
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/9 11:21
	 **/
	public class SwfConfig {
		//是否自动播放
		public var autoPlay:Boolean;
		//播放信息读取地址
		public var playInfoURL:String;
		//选择清晰度
		public var clear:String;
		//播放进度
		public var playPer:Number;
		public function SwfConfig(para:Object) {
			autoPlay = para["autoPlay"];
			playInfoURL = para["playInfoURL"];
			clear = para["clear"];
			playPer = para["playPer"];
			if (isNaN(playPer)) playPer = 0;
		}
		
		public function toString():String {
			var str:String = "autoPlay: " + autoPlay;
			str += ",playInfoURL: " + playInfoURL;
			str += ",clear: " + clear;
			str += ",playPer: " + playPer;
			return str;
		}
	}

}