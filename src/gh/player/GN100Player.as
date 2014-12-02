package gh.player {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import gh.player.playerUI.PlayerUI;
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/11/27 15:29
	 **/
	public class GN100Player extends Sprite {
		
		private var _video:GN100Video;
		private var _chan:VideoChannel;
		private var _ui:PlayerUI;
		public function GN100Player(w:Number, h:Number) {
			_video = new GN100Video(w, h);
			_ui = new PlayerUI();
			_ui.visible = false;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		private function added(e:Event):void {
			addChild(_video.video);
			addChild(_ui);
		}
		
		/**
		 * 开始播放
		 * @param	clearName 清晰度
		 */
		public function start(chan:VideoChannel):void {
			if (chan != null) {
				_chan = chan;
				if (_video.connected == false) {
					_video.addEventListener(GN100Video.STATUS_CHANG, videoStatusChange);
					_video.start(_chan.list[0]);
					startLiveTime();
				}
			}
		}
		public function closed():void {
			if (_video.connected) {
				stopLiveTime();
				_ui.visible = false;
				_ui.close();
				_video.closed();
				_video.removeEventListener(GN100Video.STATUS_CHANG, videoStatusChange);
			}
		}
		private function videoStatusChange(e:Event):void {
			if (_video.playing) {
				setUIState(_video.state);
			} else {
				if (_video.connected) {
					_ui.visible = true;
					_ui.start(_chan, startVideo, pauseVideo);
				}
			}
		}
		public function setUIState(state:String):void {
			switch(state) {
				case GN100Video.STARTING:
				case GN100Video.STOPPING:
				case GN100Video.STOPPED:
				case GN100Video.PAUSED:
					_ui.setPlayState(false, state);
					break;
				case GN100Video.STARTED:
					_ui.setPlayState(true, state);
					break;
			}
		}
		
		public function startVideo():void {
			_video.startPlay();
		}
		public function pauseVideo():void {
			_video.pausePlay();
		}
		
		private var _timer:Timer;
		public function startLiveTime():void {
			if (_timer == null) {
				_timer = new Timer(1000);
			}
			_timer.addEventListener(TimerEvent.TIMER, updateTime);
				_timer.start();
		}
		public function stopLiveTime():void {
			if (_timer != null) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, updateTime);
			}
		}
		private function updateTime(e:TimerEvent):void {
			if (_video.stream != null) {
				_ui.setLiveTime(_video.stream.time);
			}
		}
		/**
		 * 改变清晰度
		 * @param	clearName
		 */
		public function changleClear():void {
			var clearIndex:uint = _chan.list.indexOf(_video.playInfo);
			var clearLen:uint = _chan.list.length;
			clearIndex = (clearIndex + 1) % clearLen;
			if (clearIndex < clearLen) {
				_video.closeConnection();
				_video.connect(_chan.list[clearIndex]);
			}
		}
	}
	
}