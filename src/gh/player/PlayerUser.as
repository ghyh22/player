package gh.player {
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/11/27 16:34
	 **/
	public class PlayerUser {
		private var _id:String;
		private var _token:String;
		private var _ipArea:String;
		private var _ipOp:String;
		public function PlayerUser(id:String, token:String, ipArea:String = "", ipOp:String = "") {
			_id = id;
			_token = token;
			_ipArea = ipArea;
			_ipOp = ipOp;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get token():String 
		{
			return _token;
		}
		
		public function get ipArea():String 
		{
			return _ipArea;
		}
		
		public function get ipOp():String 
		{
			return _ipOp;
		}
	}

}