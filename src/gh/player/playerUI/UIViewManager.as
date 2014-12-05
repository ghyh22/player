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
		private var _playManager:PlayUIManager;
		private var _bottom:Sprite;
		private var _uiTimer:Timer;
		private var _showTimer:Timer;
		public function UIViewManager(view:Sprite, clear:ClearManager, sound:SoundManager, progress:PlayProgress, playManager:PlayUIManager) {
			_view = view;
			_clear = clear;
			_sound = sound;
			_progress = progress;
			_playManager = playManager;
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
			LOG.addStep("UIView.start");
			_uiTimer.addEventListener(TimerEvent.TIMER, uiTimerEvent);
			_uiTimer.addEventListener(TimerEvent.TIMER_COMPLETE, uiTimerComplete);
			_showTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showTimerComplete);
			_bottom.addEventListener(MouseEvent.MOUSE_OVER, onOverBottom);
		}
		public function close():void {
			LOG.addStep("UIView.close");
			closeSwitch();
			_bottom.removeEventListener(MouseEvent.MOUSE_OVER, onOverBottom);
			_showTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, showTimerComplete);
			_uiTimer.removeEventListener(TimerEvent.TIMER, uiTimerEvent);
			_uiTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, uiTimerComplete);
		}
		private function onOverBottom(e:MouseEvent):void {
			switchToUIview();
		}
		private function onOverView(e:MouseEvent):void {
			stopHideTimer();
			switchToUIview();
		}
		private function onOutView(e:MouseEvent):void {
			startHideTimer();
		}
		
		/**
		 * 开启切换
		 */
		public function startSwitch():void {
			_view.addEventListener(MouseEvent.MOUSE_OUT, onOutView);
			_view.addEventListener(MouseEvent.MOUSE_OVER, onOverView);
			startHideTimer();
		}
		/**
		 * 关闭切换
		 */
		public function closeSwitch():void {
			stopHideTimer();
			_view.removeEventListener(MouseEvent.MOUSE_OUT, onOutView);
			_view.removeEventListener(MouseEvent.MOUSE_OVER, onOverView);
		}
		
		/**
		 * 开启切换隐藏计时
		 */
		private function startHideTimer():void {
			_showTimer.reset();
			_showTimer.start();
		}
		/**
		 * 停止切换隐藏计时并停止播放隐藏动画
		 */
		private function stopHideTimer():void {
			_showTimer.stop();
			stopHideUI();
		}
		private function showTimerComplete(e:TimerEvent):void {
			startHideUI();
		}
		/**
		 * 开始播放隐藏动画
		 */
		private function startHideUI():void {
			_uiTimer.reset();
			_uiTimer.start();
		}
		/**
		 * 停止播放隐藏动画并切换为显示UI
		 */
		private function stopHideUI():void {
			if(_uiTimer.running) _uiTimer.stop();
		}
		private function uiTimerEvent(e:TimerEvent):void {
			_view.alpha -= 0.09;
		}
		private function uiTimerComplete(e:TimerEvent):void {
			switchToBottom();
		}
		
		/**
		 * 切换到显示UI
		 */
		public function switchToUIview():void {
			stopHideTimer();
			_bottom.visible = false;
			_view.alpha = 1;
			_view.visible = true;
		}
		/**
		 * 切换为隐藏UI
		 * UI隐藏时取消声音,播放进度,清晰度动作
		 */
		public function switchToBottom():void {
			stopHideTimer();
			_bottom.visible = true;
			_view.visible = false;
			
			_sound.hideVolume();
			_progress.stopDragPlay();
			_clear.hideList();
			_playManager.hideTips();
		}
		
		public function get bottom():Sprite{
			return _bottom;
		}
	}

}