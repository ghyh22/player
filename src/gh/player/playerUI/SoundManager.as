package gh.player.playerUI {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/3 11:34
	 **/
	public class SoundManager {
		private var _sound:SimpleButton;
		private var _silence:SimpleButton;
		private var _volume:Sprite;
		private var _progress:Sprite;
		private var _txt:TextField;
		private var _fillY:Number;
		private var _fillLen:Number;
		private var _timer:Timer;
		private var _hideTimer:Timer;
		public function SoundManager(sound:SimpleButton, silence:SimpleButton, volume:Sprite) {
			_sound = sound;
			_silence = silence;
			_volume = volume;
			_progress = _volume.getChildByName("progressMc") as Sprite;
			_txt = _volume.getChildByName("volumeTxtMc") as TextField;
			_fillY = _progress.y;
			_fillLen = _progress.height;
			_timer = new Timer(30, 10);
			_hideTimer = new Timer(2000, 1);
			setVolume(0);
			initStatus();
		}
		private function initStatus():void {
			_sound.visible = false;
			_silence.visible = false;
			_volume.visible = false;
			_volume.mouseChildren = false;
			setVolume(0);
		}
		
		private var _mute:Function;
		private var _unmute:Function;
		private var _setVolume:Function;
		public function start(mute:Function, unmute:Function, setVolume:Function):void {
			LOG.addStep("Sound.start");
			_mute = mute;
			_unmute = unmute;
			_setVolume = setVolume;
			_sound.visible = true;
			_sound.addEventListener(MouseEvent.CLICK, onClick);
			_sound.addEventListener(MouseEvent.MOUSE_OVER, onOverSound);
			_volume.addEventListener(MouseEvent.MOUSE_OVER, onOverVolume);
			_volume.addEventListener(MouseEvent.MOUSE_OUT, onOutVolume);
			_volume.addEventListener(MouseEvent.MOUSE_DOWN, downVolume);
			_silence.addEventListener(MouseEvent.CLICK, onClick);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showComplete);
		}
		public function close():void {
			LOG.addStep("sound.close");
			hideVolume();
			_sound.removeEventListener(MouseEvent.CLICK, onClick);
			_sound.removeEventListener(MouseEvent.MOUSE_OVER, onOverSound);
			_volume.removeEventListener(MouseEvent.MOUSE_OVER, onOverVolume);
			_volume.removeEventListener(MouseEvent.MOUSE_OUT, onOutVolume);
			_volume.removeEventListener(MouseEvent.MOUSE_DOWN, downVolume);
			_silence.removeEventListener(MouseEvent.CLICK, onClick);
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_hideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showComplete);
			initStatus();
		}
		private function onOverSound(e:MouseEvent):void {
			showVolume();
		}
		private function onOverVolume(e:MouseEvent):void {
			stopHideTimer();
		}
		private function onOutVolume(e:MouseEvent):void {
			hideVolume();
		}
		private function onClick(e:MouseEvent):void {
			switch(e.currentTarget) {
				case _sound:
					_mute();
					break;
				case _silence:
					_unmute();
					break;
			}
		}
		private function downVolume(e:MouseEvent):void {
			var cy:Number = e.localY;
			var volumeVar:Number = Math.abs(cy - (_fillY + _fillLen / 2)) / _fillLen;
			_setVolume(volumeVar);
			startMoveVolume();
		}
		private function startMoveVolume():void {
			_volume.addEventListener(MouseEvent.MOUSE_MOVE, moveVolume);
			_volume.addEventListener(MouseEvent.MOUSE_UP, upVolume);
		}
		private function stopMoveVolume():void {
			_volume.removeEventListener(MouseEvent.MOUSE_MOVE, moveVolume);
			_volume.removeEventListener(MouseEvent.MOUSE_UP, upVolume);
		}
		private function moveVolume(e:MouseEvent):void {
			var cy:Number = e.localY;
			var volumeVar:Number = Math.abs(cy - (_fillY + _fillLen / 2)) / _fillLen;
			_setVolume(volumeVar);
		}
		private function upVolume(e:MouseEvent):void {
			stopMoveVolume();
		}
		/**
		 * 显示播放动画
		 */
		public function showVolume():void {
			_volume.visible = true;
			_volume.alpha = 0;
			_timer.reset();
			_timer.start();
			//startHideTimer();
		}
		/**
		 * 隐藏并停止播放显示动画
		 * 并且停止开启隐藏的计时
		 * 停止控制器上的操作控制
		 */
		public function hideVolume():void {
			stopHideTimer();
			stopMoveVolume();
			_volume.visible = false;
			_timer.stop();
		}
		private function onTimer(e:TimerEvent):void {
			_volume.alpha += 0.1;
		}
		private function onTimerComplete(e:TimerEvent):void {
			startHideTimer();
		}
		
		/**
		 * 开始开启隐藏的计时
		 */
		private function startHideTimer():void {
			_hideTimer.reset();
			_hideTimer.start();
		}
		/**
		 * 停止开启隐藏的计时
		 */
		private function stopHideTimer():void {
			_hideTimer.stop();
		}
		private function showComplete(e:TimerEvent):void {
			_volume.visible = false;
		}
		
		public function setVolume(volume:Number):void {
			_progress.y = _fillY + _fillLen * (1 - volume);
			_txt.text = Math.floor(volume * 100).toString();
		}
		public function setMute(flag:Boolean):void {
			_silence.visible = flag;
			_sound.visible = !flag;
			if (flag)_volume.visible = false;
		}
	}

}