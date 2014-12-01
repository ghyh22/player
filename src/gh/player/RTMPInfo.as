package gh.player {
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/11/27 15:56
	 **/
	public class RTMPInfo {
		
		public var clear:String;
		public var url:String;
		public var stream:String;
		public var cdnID:String;
		public function RTMPInfo(clear:String, url:String, stream:String, cdnID:String = "") {
			this.clear = clear;
			this.url = url;
			this.stream = stream;
			this.cdnID = cdnID;
		}
		
	}

}