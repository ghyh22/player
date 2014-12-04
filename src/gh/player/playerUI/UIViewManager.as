package gh.player.playerUI {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/3 16:05
	 **/
	public class UIViewManager {
		private var _view:Sprite;
		private var _clear:ClearManager;
		private var _sound:SoundManager;
		private var _progress:PlayProgress;
		private var _bottom:Sprite;
		private var _uiTimer:Timer;
		private var _showTimer:Timer;
		public function UIViewManager(view:Sprite, clear:ClearManager, sound:SoundManager, progress:PlayProgress) {
			_view = view;
			_clear = clear;
			_sound = sound;
			_progress = progress;
			initBottom();
			_uiTimer = new Timer(30, 10);
			_showTimer = new Timer(2000, 1);
		}
		private function initBottom():void {
			_bottom = new Sprite();
			_bottom.graphics.beginFill(0x000000);
			_bottom.graphics.drawRect(0, 0, _view.width, 20);
			_bottom.graphics.endFill();
			_bottom.alpha = 0;
			_bottom.visible = false;
		}
		public function start():void {
			LOG.show("UIView.start");
			_uiTimer.addEventListener(TimerEvent.TIMER, uiTimerEvent);
			_uiTimer.addEventListener(TimerEvent.TIMER_COMPLETE, uiTimerComplete);
			_showTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showTimerComplete);
			_bottom.addEventListener(MouseEvent.MOUSE_OVER, onOverBottom);
		}
		public function close():void {
			LOG.show("UIView.close");
			stopSwitch();
			_bottom.removeEventListener(MouseEvent.MOUSE_OVER, onOverBottom);
			_showTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showTimerComplete);
			_uiTimer.removeEventListener(TimerEvent.TIMER, uiTimerEvent);
			_uiTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, uiTimerComplete);
		}
		private function onOverBottom(e:MouseEvent):void {
			stopUITimer();
		}
		
		public function startSwitch():void {
			LOG.show("UIView.startSwitch");
			_view.addEventListener(MouseEvent.MOUSE_OUT, onOutView);
			_view.addEventListener(MouseEvent.MOUSE_OVER, onOverView);
			startUITimer();
		}
		public function stopSwitch():void {
			LOG.show("UIView.stopSwitch");
			stopUITimer();
			_view.removeEventListener(MouseEvent.MOUSE_OUT, onOutView);
			_view.removeEventListener(MouseEvent.MOUSE_OVER, onOverView);
		}
		private function onOverView(e:MouseEvent):void {
			stopUITimer();
		}
		private function onOutView(e:MouseEvent):void {
			startUITimer();
		}
		
		private function startUITimer():void {
			_showTimer.reset();
			_showTimer.start();
		}
		private function stopUITimer():void {
			_showTimer.stop();
			stopHideUI();
		}
		private function showTimerComplete(e:TimerEvent):void {
			startHideUI();
		}
		private function startHideUI():void {
			_uiTimer.reset();
			_uiTimer.start();
		}
		private function stopHideUI():void {
			_uiTimer.stop();
			switchToUIview();
		}
		private function uiTimerEvent(e:TimerEvent):void {
			_view.alpha -= 0.09;
		}
		private function uiTimerComplete(e:TimerEvent):void {
			switchToBottom();
		}
		
		private function switchToUIview():void {
			_bottom.visible = false;
			_view.alpha = 1;
			_view.visible = true;
		}
		private function switchToBottom():void {
			_bottom.visible = true;
			_view.visible = false;
			_sound.hideVolume();
			_progress.stopDragPlay();
			_clear.hideList();
		}
		
		public function get bottom():Sprite{
			return _bottom;
		}
	}

}