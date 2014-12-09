package gh.player {
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/9 16:53
	 **/
	public class PlayerInfo {
		private var _user:PlayerUser;
		private var _chan:VideoChannel;
		public function PlayerInfo(user:PlayerUser, chan:VideoChannel) {
			_user = user;
			_chan = chan;
		}
		
		public function get user():PlayerUser{
			return _user;
		}
		public function get chan():VideoChannel{
			return _chan;
		}
		
	}

}