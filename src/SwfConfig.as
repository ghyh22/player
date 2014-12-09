package  {
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/9 11:21
	 **/
	public class SwfConfig {
		public var autoPlay:Boolean;
		public var playInfo:String;
		public function SwfConfig(para:Object) {
			autoPlay = para["autoPlay"];
			playInfo = para["playInfo"];
		}
		
	}

}