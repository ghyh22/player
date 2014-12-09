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
		public static const SD:String = "超清";
		public static const HD:String = "高清";
		public static const BD:String = "标清";
		
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
		public function start(chan:VideoChannel, autoPlay:Boolean = false):void {
			if (chan != null && chan.list.length > 0) {
				if (_video.connected == false) {
					LOG.addStep("Player.start");
					_chan = chan;
					_video.addEventListener(GN100Video.CONNECTION, videoConnection);
					_video.addEventListener(GN100Video.STATUS_CHANG, videoStatusChange);
					_video.addEventListener(GN100Video.METE_DATA, videoMeteData);
					_video.start(_chan.list[0], autoPlay);
				}
			}
		}
		public function closed():void {
			if (_video.connected) {
				LOG.addStep("Player.close");
				uiClose();
				_video.closed();
				_video.removeEventListener(GN100Video.METE_DATA, videoMeteData);
				_video.removeEventListener(GN100Video.STATUS_CHANG, videoStatusChange);
				_video.removeEventListener(GN100Video.CONNECTION, videoConnection);
			}
		}
		private function videoConnection(e:ParaEvent):void {
			switch(e.para["info"]) {
				case "NetConnection.Connect.Success":
					uiStart();
                    break;
				case "NetConnection.Connect.Failed":
					LOG.show("connect failed");
					break;
				case "NetConnection.Connect.Closed":
					uiClose();
					break;
			}
		}
		private function videoStatusChange(e:Event):void {
			switch(_video.state) {
				case GN100Video.STARTED:
					_ui.sound.setVolume(_video.volume);
					_ui.uiManager.startSwitch();
					break;
				case GN100Video.STOPPED:
					_ui.uiManager.closeSwitch();
					break;
			}
			_ui.setPlayState(_video.state);
		}
		private function videoMeteData(e:Event):void {
			if (_video.remoting == false){
				_ui.playProgress.start(jumpProgress, _video.totalTime);
			}
			
			startCountTime();
		}
		
		public function uiStart():void {
			LOG.addStep("Player.uiStart");
			_ui.start(_video.remoting);
			_ui.uiManager.start();
			_ui.playUI.start(startVideo, pauseVideo);
			_ui.sound.start(mute, unmute, setVolume);
			_ui.clear.start(_chan.list, changleClear);
			_ui.clear.chooseClear(_video.playInfo.name);
			_ui.setPlayState(_video.state);
		}
		public function uiClose():void {
			LOG.addStep("Player.uiClose");
			stopCountTime();
			_ui.playProgress.close();
			_ui.sound.close();
			_ui.clear.close();
			_ui.playUI.close();
			_ui.uiManager.close();
			_ui.close();
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
		public function mute():void {
			_video.mute();
			_ui.sound.setMute(true);
			_ui.sound.setVolume(_video.volume);
		}
		public function unmute():void {
			_video.unmute();
			_ui.sound.setMute(false);
			_ui.sound.setVolume(_video.volume);
		}
		public function setVolume(volume:Number):void {
			_video.setVolume(volume);
			_ui.sound.setVolume(_video.volume);
		}
		
		public function jumpProgress(per:Number):void {
			_video.setProgress(per);
		}
		
		private var _timer:Timer;
		/**
		 * 开始显示影片的播放时间
		 * 每秒统计一次
		 */
		public function startCountTime():void {
			if (_timer == null) {
				_timer = new Timer(200);
			}
			_timer.addEventListener(TimerEvent.TIMER, updateTime);
			_timer.start();
		}
		/**
		 * 停止显示影片的播放时间
		 */
		public function stopCountTime():void {
			if (_timer != null) {
				_ui.setLiveTime(0);
				_ui.playProgress.setPlayTime(0);
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, updateTime);
			}
		}
		private function updateTime(e:TimerEvent):void {
			if (_video.state == GN100Video.STARTED) {
				if (_video.remoting) {
					_ui.setLiveTime(_video.stream.time);
				}else {
					_ui.playProgress.setPlayTime(_video.stream.time);
				}
			}
		}
		/**
		 * 改变清晰度
		 * @param	clearName
		 */
		public function changleClear(name:String):void {
			if (_video.connected) {
				_video.closed();
				_video.start(_chan.getInfo(name), true);
			}
		}
	}
	
}