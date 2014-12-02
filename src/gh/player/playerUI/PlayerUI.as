package gh.player.playerUI {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
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
		private var _pauseButton:SimpleButton;
		private var _fullButton:SimpleButton;
		private var _liveTime:TextField;
		private var _clear:ClearManager;
		public function PlayerUI() {
			_view = Main.EC.getElement(ELL.UI_UILayer) as Sprite;
			_bg = _view.getChildByName("bgMc") as Sprite;
			_bg.alpha = 0.7;
			_playButton = _view.getChildByName("playMc") as SimpleButton;
			_playButton.enabled = false;
			_playButton.mouseEnabled = false;
			_pauseButton = _view.getChildByName("pauseMc") as SimpleButton;
			_pauseButton.visible = false;
			setPlayState(GN100Video.STOPPED);
			_fullButton = _view.getChildByName("fullMc") as SimpleButton;
			_liveTime = _view.getChildByName("liveTimeMc") as TextField;
			var clear:Sprite = _view.getChildByName("clearMc") as Sprite;
			var clearList:Sprite = _view.getChildByName("clearListMc") as Sprite;
			_clear = new ClearManager(clear, clearList);
			setLiveTime(0);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		private function added(e:Event):void {
			_view.x = 0;
			_view.y = stage.stageHeight - BOTTOM_HEIGHT;
			addChild(_view);
		}
		
		private var _playFun:Function;
		private var _pauseFun:Function;
		public function start(chan:VideoChannel, play:Function, pause:Function):void {
			_playFun = play;
			_pauseFun = pause;
			_playButton.addEventListener(MouseEvent.CLICK, onPlay);
			_pauseButton.addEventListener(MouseEvent.CLICK, onPause);
			_fullButton.addEventListener(MouseEvent.CLICK, fullScreen);
			_clear.start(chan.list);
		}
		public function close():void {
			_clear.close();
			_fullButton.removeEventListener(MouseEvent.CLICK, fullScreen);
			_playButton.removeEventListener(MouseEvent.CLICK, onPause);
			_playButton.removeEventListener(MouseEvent.CLICK, onPlay);
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
					break;
				case GN100Video.STARTED:
					_playButton.visible = false;
					
					_pauseButton.visible = true;
					_pauseButton.enabled = true;
					_pauseButton.mouseEnabled = true;
					break;
				case GN100Video.STOPPING:
					_playButton.visible = false;
					
					_pauseButton.visible = true;
					_pauseButton.enabled = false;
					_pauseButton.mouseEnabled = false;
					break;
				case GN100Video.STOPPED:
					_playButton.visible = true;
					_playButton.enabled = true;
					_playButton.mouseEnabled = true;
					
					_pauseButton.visible = false;
					break;
				case GN100Video.PAUSED:
					_playButton.visible = true;
					_playButton.enabled = true;
					_playButton.mouseEnabled = true;
					
					_pauseButton.visible = false;
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
	}
	
}