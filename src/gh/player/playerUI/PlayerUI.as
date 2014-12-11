package gh.player.playerUI {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import gh.element.util.ELL;
	import gh.player.GN100Player;
	import gh.player.GN100Video;
	import gh.player.VideoChannel;
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/1 11:58
	 **/
	public class PlayerUI extends Sprite {
		public static const BOTTOM_HEIGHT:Number = 40;
		
		private var _view:Sprite;
		private var _loading:Sprite;
		private var _bg:Sprite;
		private var _playUI:PlayUIManager;
		private var _clear:ClearManager;
		private var _sound:SoundManager;
		private var _uiManager:UIViewManager;
		private var _playProgress:PlayProgress;
		private var _fullButton:SimpleButton;
		private var _quitFull:SimpleButton;
		private var _liveTime:TextField;
		public function PlayerUI() {
			_view = Main.EC.getElement(ELL.UI_UILayer) as Sprite;
			_loading = Main.EC.getElement(ELL.UI_Loading) as Sprite;
			_bg = _view.getChildByName("bgMc") as Sprite;
			initClear();
			initSound();
			initPlayUI();
			var progress:Sprite = _view.getChildByName("playProgressMc") as Sprite;
			_playProgress = new PlayProgress(progress);
			_uiManager = new UIViewManager(_view, _clear, _sound, _playProgress, _playUI);
			
			_fullButton = _view.getChildByName("fullMc") as SimpleButton;
			_quitFull = _view.getChildByName("quitFullMc") as SimpleButton;
			_liveTime = _view.getChildByName("liveTimeMc") as TextField;
			setLiveTime(0);
			addEventListener(Event.ADDED_TO_STAGE, added);
			initStatus();
		}
		private function initStatus():void {
			_fullButton.visible = false;
			_quitFull.visible = false;
			_liveTime.visible = false;
			_loading.visible = true;
			_bg.alpha = 0.7;
			setLiveTime(0);
		}
		private function initClear():void {
			var clear:Sprite = _view.getChildByName("clearMc") as Sprite;
			var clearList:Sprite = _view.getChildByName("clearListMc") as Sprite;
			_clear = new ClearManager(clear, clearList);
		}
		private function initSound():void {
			var sound:SimpleButton = _view.getChildByName("soundMc") as SimpleButton;
			var mute:SimpleButton = _view.getChildByName("muteMc") as SimpleButton;
			var volume:Sprite = _view.getChildByName("volumeMc") as Sprite;
			_sound = new SoundManager(sound, mute, volume);
		}
		private function initPlayUI():void {
			var play:SimpleButton = _view.getChildByName("playMc") as SimpleButton;
			var playTip:Sprite = _view.getChildByName("playTipMc") as Sprite;
			var pause:SimpleButton = _view.getChildByName("pauseMc") as SimpleButton;
			var pauseTip:Sprite = _view.getChildByName("pauseTipMc") as Sprite;
			_playUI = new PlayUIManager(play, playTip, pause, pauseTip);
		}
		private function added(e:Event):void {
			_loading.x = stage.stageWidth / 2;
			_loading.y = stage.stageHeight / 2 - BOTTOM_HEIGHT;
			addChild(_loading);
			_uiManager.bottom.y = stage.stageHeight - _uiManager.bottom.height;
			addChild(_uiManager.bottom);
			_view.x = 0;
			_view.y = stage.stageHeight - BOTTOM_HEIGHT;
			addChild(_view);
		}
		
		public function start(remoting:Boolean):void {
			LOG.addStep("UI.start");
			if (remoting)_liveTime.visible = true;
			setFullScreen();
			_loading.visible = false;
			_fullButton.addEventListener(MouseEvent.CLICK, fullScreen);
			_quitFull.addEventListener(MouseEvent.CLICK, quitFullScreen);
		}
		public function close():void {
			LOG.addStep("UI.close");
			_quitFull.removeEventListener(MouseEvent.CLICK, quitFullScreen);
			_fullButton.removeEventListener(MouseEvent.CLICK, fullScreen);
			initStatus();
		}
		private function fullScreen(e:MouseEvent):void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
			setFullScreen();
		}
		private function quitFullScreen(e:MouseEvent):void {
			stage.displayState = StageDisplayState.NORMAL;
			setFullScreen();
		}
		
		/**
		 * 
		 * @param	state
		 * @param	videoStatus
		 */
		public function setPlayState(videoStatus:String):void {
			_playUI.setPlayState(videoStatus);
			switch(videoStatus) {
				case GN100Video.STARTING:
					_bg.alpha = 0.7;
					break;
				case GN100Video.STARTED:
					_bg.alpha = 0.5;
					break;
				case GN100Video.STOPPING:
					_bg.alpha = 0.7;
					break;
				case GN100Video.STOPPED:
					_bg.alpha = 0.7;
					break;
				case GN100Video.PAUSED:
					_bg.alpha = 0.7;
					break;
			}
		}
		
		public function setLiveTime(time:Number):void {
			var m:uint = time / 60;
			var s:uint = time % 60;
			var tmp:String = "";
			if (m < 10) {
				tmp += "0";
			}
			tmp += m;
			tmp += ":";
			if (s < 10) {
				tmp += "0";
			}
			tmp += s;
			_liveTime.text = tmp;
		}
		
		public function setFullScreen():void {
			var flag:Boolean = (stage.displayState == StageDisplayState.NORMAL);
			_fullButton.visible = flag;
			_quitFull.visible = !flag;
		}
		
		public function get clear():ClearManager{
			return _clear;
		}
		
		public function get sound():SoundManager{
			return _sound;
		}
		
		public function get playProgress():PlayProgress{
			return _playProgress;
		}
		
		public function get playUI():PlayUIManager{
			return _playUI;
		}
		
		public function get uiManager():UIViewManager{
			return _uiManager;
		}
	}
	
}