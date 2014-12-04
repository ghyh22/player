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
		private var _bg:Sprite;
		private var _playButton:SimpleButton;
		private var _playTip:Sprite;
		private var _pauseButton:SimpleButton;
		private var _pauseTip:Sprite;
		private var _fullButton:SimpleButton;
		private var _liveTime:TextField;
		private var _clear:ClearManager;
		private var _sound:SoundManager;
		private var _uiManager:UIViewManager;
		private var _playProgress:PlayProgress;
		public function PlayerUI() {
			_view = Main.EC.getElement(ELL.UI_UILayer) as Sprite;
			initClear();
			initSound();
			var progress:Sprite = _view.getChildByName("playProgressMc") as Sprite;
			_playProgress = new PlayProgress(progress);
			_uiManager = new UIViewManager(_view, _clear, _sound, _playProgress);
			_bg = _view.getChildByName("bgMc") as Sprite;
			_bg.alpha = 0.7;
			_playButton = _view.getChildByName("playMc") as SimpleButton;
			_playButton.enabled = false;
			_playButton.mouseEnabled = false;
			_playButton.visible = false;
			_playTip = _view.getChildByName("playTipMc") as Sprite;
			_playTip.visible = false;
			_pauseButton = _view.getChildByName("pauseMc") as SimpleButton;
			_pauseButton.visible = false;
			_pauseButton.enabled = false;
			_pauseButton.mouseEnabled = false;
			_pauseTip = _view.getChildByName("pauseTipMc") as Sprite;
			_pauseTip.visible = false;
			setPlayState(GN100Video.STOPPED);
			_fullButton = _view.getChildByName("fullMc") as SimpleButton;
			_liveTime = _view.getChildByName("liveTimeMc") as TextField;
			setLiveTime(0);
			addEventListener(Event.ADDED_TO_STAGE, added);
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
		private function added(e:Event):void {
			_view.x = 0;
			_view.y = stage.stageHeight - BOTTOM_HEIGHT;
			_uiManager.bottom.y = stage.stageHeight - _uiManager.bottom.height;
			addChild(_uiManager.bottom);
			addChild(_view);
			
		}
		
		private var _playFun:Function;
		private var _pauseFun:Function;
		public function start(remoting:Boolean, play:Function, pause:Function):void {
			LOG.show("UI.start");
			if (remoting) {
				_playProgress.view.visible = false;
			}else {
				_liveTime.visible = false;
			}
			_playFun = play;
			_pauseFun = pause;
			_playButton.addEventListener(MouseEvent.CLICK, onPlay);
			_playButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_playButton.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_pauseButton.addEventListener(MouseEvent.CLICK, onPause);
			_pauseButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_pauseButton.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_fullButton.addEventListener(MouseEvent.CLICK, fullScreen);
			_uiManager.start();
		}
		public function close():void {
			LOG.show("UI.close");
			_uiManager.close();
			_fullButton.removeEventListener(MouseEvent.CLICK, fullScreen);
			_pauseButton.removeEventListener(MouseEvent.CLICK, onPause);
			_pauseButton.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_pauseButton.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_playButton.removeEventListener(MouseEvent.CLICK, onPlay);
			_playButton.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_playButton.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_playFun = null;
		}
		private function onPlay(e:MouseEvent):void {
			_playFun();
		}
		private function onPause(e:MouseEvent):void {
			_pauseFun();
		}
		private function fullScreen(e:MouseEvent):void {
			LOG.show(stage.displayState);
			if (stage.displayState == StageDisplayState.FULL_SCREEN || stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
				stage.displayState = StageDisplayState.NORMAL;
			}else {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		private function onOver(e:MouseEvent):void {
			switch(e.currentTarget) {
				case _playButton:
					_playTip.visible = true;
					break;
				case _pauseButton:
					_pauseTip.visible = true;
					break;
			}
		}
		private function onOut(e:MouseEvent):void {
			switch(e.currentTarget) {
				case _playButton:
					_playTip.visible = false;
					break;
				case _pauseButton:
					_pauseTip.visible = false;
					break;
			}
		}
		
		/**
		 * 
		 * @param	state
		 * @param	videoStatus
		 */
		public function setPlayState(videoStatus:String):void {
			switch(videoStatus) {
				case GN100Video.STARTING:
					_playButton.visible = true;
					_playButton.enabled = false;
					_playButton.mouseEnabled = false;
					
					_pauseButton.visible = false;
					_bg.alpha = 0.7;
					break;
				case GN100Video.STARTED:
					_playButton.visible = false;
					
					_pauseButton.visible = true;
					_pauseButton.enabled = true;
					_pauseButton.mouseEnabled = true;
					_bg.alpha = 0.5;
					_uiManager.startSwitch();
					break;
				case GN100Video.STOPPING:
					_playButton.visible = false;
					
					_pauseButton.visible = true;
					_pauseButton.enabled = false;
					_pauseButton.mouseEnabled = false;
					_bg.alpha = 0.7;
					_uiManager.stopSwitch();
					break;
				case GN100Video.STOPPED:
					_playButton.visible = true;
					_playButton.enabled = true;
					_playButton.mouseEnabled = true;
					
					_pauseButton.visible = false;
					_bg.alpha = 0.7;
					_uiManager.stopSwitch();
					break;
				case GN100Video.PAUSED:
					_playButton.visible = true;
					_playButton.enabled = true;
					_playButton.mouseEnabled = true;
					
					_pauseButton.visible = false;
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
		
		public function get clear():ClearManager{
			return _clear;
		}
		
		public function get sound():SoundManager{
			return _sound;
		}
		
		public function get playProgress():PlayProgress{
			return _playProgress;
		}
	}
	
}