package gh.player.playerUI {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gh.player.GN100Video;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/5 10:31
	 **/
	public class PlayUIManager {
		private var _playButton:SimpleButton;
		private var _playTip:Sprite;
		private var _pauseButton:SimpleButton;
		private var _pauseTip:Sprite;
		public function PlayUIManager(play:SimpleButton, playTip:Sprite, pause:SimpleButton, pauseTip:Sprite) {
			_playButton = play;
			_playButton.enabled = false;
			_playButton.mouseEnabled = false;
			_playButton.visible = false;
			_playTip = playTip;
			_playTip.visible = false;
			
			_pauseButton = pause;
			_pauseButton.visible = false;
			_pauseButton.enabled = false;
			_pauseButton.mouseEnabled = false;
			_pauseTip = pauseTip;
			_pauseTip.visible = false;
		}
		private function initState():void {
			_playButton.enabled = false;
			_playButton.mouseEnabled = false;
			_playButton.visible = false;
			_playTip.visible = false;
			
			_pauseButton.visible = false;
			_pauseButton.enabled = false;
			_pauseButton.mouseEnabled = false;
			_pauseTip.visible = false;
		}
		
		private var _playFun:Function;
		private var _pauseFun:Function;
		public function start(play:Function, pause:Function):void {
			LOG.show("PlayUI.start");
			_playFun = play;
			_pauseFun = pause;
			_playButton.addEventListener(MouseEvent.CLICK, onPlay);
			_playButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_playButton.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_pauseButton.addEventListener(MouseEvent.CLICK, onPause);
			_pauseButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_pauseButton.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		public function close():void {
			LOG.show("PlayUI.close");
			initState();
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
		
		public function hideTips():void {
			_pauseTip.visible = false;
			_playTip.visible = false;
		}
	}

}