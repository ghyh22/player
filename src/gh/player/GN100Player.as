package gh.player {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import gh.events.ParaEvent;
	import gh.player.playerUI.ClearManager;
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
					_video.addEventListener(GN100Video.CONNECTION, videoConnection);
					_video.addEventListener(GN100Video.STATUS_CHANG, videoStatusChange);
					_video.start(_chan.list[0]);
					startLiveTime();
					uiStart();
				}
			}
		}
		public function closed():void {
			if (_video.connected) {
				uiClose();
				stopLiveTime();
				_video.closed();
				_video.removeEventListener(GN100Video.STATUS_CHANG, videoStatusChange);
				_video.removeEventListener(GN100Video.CONNECTION, videoConnection);
			}
		}
		private function videoConnection(e:ParaEvent):void {
			switch(e.para["info"]) {
				case "NetConnection.Connect.Success":
					var clearIndex:uint = _chan.list.indexOf(_video.playInfo);
					_ui.clear.chooseClear(clearIndex);
                    break;
				case "NetConnection.Connect.Failed":
					
					break;
				case "NetConnection.Connect.Closed":
					
					break;
			}
		}
		private function videoStatusChange(e:Event):void {
			_ui.setPlayState(_video.state);
		}
		
		public function uiStart():void {
			_ui.start(_chan, startVideo, pauseVideo);
			var clearIndex:uint = _chan.list.indexOf(_video.playInfo);
			_ui.clear.chooseClear(clearIndex);
			_ui.clear.addEventListener(ClearManager.CLEAR_CHANGE, clearChangeEvent);
		}
		public function uiClose():void {
			_ui.clear.removeEventListener(ClearManager.CLEAR_CHANGE, clearChangeEvent);
			_ui.close();
		}
		private function clearChangeEvent(e:ParaEvent):void {
			changleClear(e.para["clearIndex"]);
		}
		public function startVideo():void {
			if (_video.connected) {
				_video.startPlay();
			}
		}
		public function pauseVideo():void {
			if (_video.connected) {
				_video.pausePlay();
			}
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
		public function changleClear(index:uint):void {
			if (_video.connected) {
				if (index < _chan.list.length) {
					_video.closed();
					_video.start(_chan.list[index], true);
				}
			}
		}
	}
	
}