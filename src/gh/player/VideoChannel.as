package gh.player {
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/11/27 16:20
	 * 频道
	 **/
	public class VideoChannel {
		private var _id:String;
		private var _list:Vector.<RTMPInfo>;
		public function VideoChannel(id:String, list:Vector.<RTMPInfo>) {
			_id = id;
			_list = list;
		}
		public function getInfo(clearName:String):RTMPInfo {
			for (var i:int = 0; i < _list.length; i ++) {
				if (_list[i].clear == clearName) {
					return _list[i];
				}
			}
			return null;
		}
		public function indexOf(clearName:String):int {
			for (var i:int = 0; i < _list.length; i ++) {
				if (_list[i].clear == clearName) {
					return i;
				}
			}
			return -1;
		}
		
		public function get id():String {
			return _id;
		}
		public function get list():Vector.<RTMPInfo> {
			return _list;
		}
	}

}