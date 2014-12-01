package gh.player {
	import flash.display.Sprite;
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/11/27 15:29
	 **/
	public class GN100Player extends Sprite {
		public static const BD:String = "超清";
		public static const HD:String = "高清";
		public static const SD:String = "标清";
		
		private var _video:GN100Video;
		private var _playerInfo:RTMPInfo;
		public function GN100Player(w:Number, h:Number) {
			_video = new GN100Video(w, h);
		}
		
		/**
		 * 开始播放
		 * @param	clearName 清晰度
		 */
		public function start(info:RTMPInfo):void {
			if (info != null) {
				_playerInfo = info;
				addChild(_video.video);
				_video.start(info.url, info.stream);
			}
		}
		public function closed():void {
			if (_video.running) {
				_video.closed();
				removeChild(_video.video);
				_playerInfo = null;
			}
		}
		
		/**
		 * 改变清晰度
		 * @param	clearName
		 */
		public function changleClear(info:RTMPInfo):void {
			if (info != null) {
				if (_video.running) {
					_video.closed();
				}
				_playerInfo = info;
				_video.start(info.url, info.stream);
			}
		}
		
		public function get playerInfo():RTMPInfo{
			return _playerInfo;
		}
		
	}
	
}