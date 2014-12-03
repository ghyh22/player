package gh.player.playerUI {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
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
		private var _fillY:Number;
		private var _fillLen:Number;
		private var _timer:Timer;
		private var _showTimer:Timer;
		public function SoundManager(sound:SimpleButton, silence:SimpleButton, volume:Sprite) {
			_sound = sound;
			_sound.visible = true;
			_silence = silence;
			_silence.visible = false;
			_volume = volume;
			_volume.visible = false;
			_volume.mouseChildren = false;
			_progress = _volume.getChildByName("progressMc") as Sprite;
			_fillY = _progress.y;
			_fillLen = _progress.height;
			_timer = new Timer(30, 10);
			_showTimer = new Timer(2000, 1);
		}
		
		private var _mute:Function;
		private var _unmute:Function;
		private var _setVolume:Function;
		public function start(mute:Function, unmute:Function, setVolume:Function):void {
			_mute = mute;
			_unmute = unmute;
			_setVolume = setVolume;
			_sound.addEventListener(MouseEvent.CLICK, onClick);
			_sound.addEventListener(MouseEvent.MOUSE_OVER, onOverSound);
			_volume.addEventListener(MouseEvent.MOUSE_OVER, onOverVolume);
			_volume.addEventListener(MouseEvent.MOUSE_OUT, onOutVolume);
			_volume.addEventListener(MouseEvent.MOUSE_DOWN, downVolume);
			_silence.addEventListener(MouseEvent.CLICK, onClick);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_showTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showComplete);
		}
		public function close():void {
			_timer.stop();
			_sound.removeEventListener(MouseEvent.CLICK, onClick);
			_sound.removeEventListener(MouseEvent.MOUSE_OVER, onOverSound);
			_volume.removeEventListener(MouseEvent.MOUSE_OVER, onOverVolume);
			_volume.removeEventListener(MouseEvent.MOUSE_OUT, onOutVolume);
			_volume.removeEventListener(MouseEvent.MOUSE_DOWN, downVolume);
			stopMoveVolume();
			_silence.removeEventListener(MouseEvent.CLICK, onClick);
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_showTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showComplete);
		}
		private function onOverSound(e:MouseEvent):void {
			showVolume();
		}
		private function onOverVolume(e:MouseEvent):void {
			stopShowTimer();
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
			LOG.show("click volume: " + volumeVar);
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
			LOG.show("click volume: " + volumeVar);
			_setVolume(volumeVar);
		}
		private function upVolume(e:MouseEvent):void {
			stopMoveVolume();
		}
		private function onTimer(e:TimerEvent):void {
			_volume.alpha += 0.1;
		}
		
		private function showVolume():void {
			_volume.visible = true;
			_volume.alpha = 0;
			_timer.reset();
			_timer.start();
			startShowTimer();
		}
		private function hideVolume():void {
			stopShowTimer();
			stopMoveVolume();
			_volume.visible = false;
			_timer.stop();
		}
		
		private function startShowTimer():void {
			_showTimer.reset();
			_showTimer.start();
		}
		private function stopShowTimer():void {
			_showTimer.stop();
		}
		private function showComplete(e:TimerEvent):void {
			hideVolume();
		}
		
		public function setVolume(volume:Number):void {
			_progress.y = _fillY + _fillLen * (1 - volume);
		}
		public function setMute(flag:Boolean):void {
			_silence.visible = flag;
			_sound.visible = !flag;
			if (flag)_volume.visible = false;
		}
	}

}