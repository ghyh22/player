package gh.player.playerUI {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import gh.events.ParaEvent;
	import gh.player.RTMPInfo;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/2 10:52
	 **/
	public class ClearManager extends EventDispatcher {
		public static const CLEAR_CHANGE:String = "clear changed";
		
		private var _list:Vector.<RTMPInfo>;
		private var _choosingIndex:int;
		private var _clear:Sprite;
		private var _clearList:Sprite;
		private var _clearName:TextField;
		private var _clearButs:Vector.<SimpleButton>;
		private var _txtList:Vector.<TextField>;
		private var _choosing:Sprite;
		private var _timer:Timer;
		private var _hideTimer:Timer;
		public function ClearManager(clear:Sprite, clearList:Sprite) {
			_clear = clear;
			_clearName = _clear.getChildByName("clearNameMc") as TextField;
			_clearList = clearList;
			_clearButs = new Vector.<SimpleButton>();
			_txtList = new Vector.<TextField>();
			_choosing = _clearList.getChildByName("choosingMc") as Sprite;
			_timer = new Timer(30, 10);
			_hideTimer = new Timer(2000, 1);
			init();
			initStatus();
		}
		private function init():void {
			var len:uint = 4;
			for (var i:int = 0; i < len; i ++) {
				var tmp:DisplayObject = _clearList.getChildByName("clear" + i + "Mc");
				SimpleButton(tmp).mouseEnabled = false;
				SimpleButton(tmp).enabled = false;
				_clearButs.push(SimpleButton(tmp));
				tmp = _clearList.getChildByName("clearTxt" + i + "Mc");
				TextField(tmp).mouseEnabled = false;
				_txtList.push(TextField(tmp));
			}
		}
		private function initStatus():void {
			_choosingIndex = -1;
			_clear.visible = false;
			_clearList.visible = false;
		}
		
		private var _clearChange:Function;
		public function start(clearList:Vector.<RTMPInfo>, change:Function):void {
			_list = clearList;
			_clearChange = change;
			_clear.visible = true;
			for (var i:int = 0; i < _txtList.length; i ++) {
				var txt:TextField = _txtList[i];
				if (i < _list.length) {
					txt.text = _list[i].clear;
					var but:SimpleButton = _clearButs[i];
					but.enabled = true;
					but.mouseEnabled = true;
					but.addEventListener(MouseEvent.CLICK, chooseClearBut);
				}else {
					txt.text = "无";
				}
			}
			_clear.addEventListener(MouseEvent.CLICK, showClearList);
			_timer.addEventListener(TimerEvent.TIMER, timerEvent);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, showTimerComplete);
			_hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideTimerComplete);
			_clearList.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_clearList.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		public function close():void {
			hideList();
			for (var i:int = 0; i < _list.length;i ++) {
				var but:SimpleButton = _clearButs[i];
				but.removeEventListener(MouseEvent.CLICK, chooseClearBut);
			}
			_clear.removeEventListener(MouseEvent.CLICK, showClearList);
			_timer.removeEventListener(TimerEvent.TIMER, timerEvent);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideTimerComplete);
			_hideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideTimerComplete);
			_clearList.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_clearList.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			initStatus();
		}
		private function showClearList(e:MouseEvent):void {
			if (_clearList.visible) {
				hideList();
			}else {
				playShowList();
			}
		}
		private function chooseClearBut(e:MouseEvent):void {
			var index:uint = _clearButs.indexOf(e.currentTarget as SimpleButton);
			_clearChange(index);
			_clearList.visible = false;
		}
		private function onOver(e:MouseEvent):void {
			stopHideList();
		}
		private function onOut(e:MouseEvent):void {
			startHideList();
		}
		
		public function chooseClear(index:uint):void {
			if (_choosingIndex == index) return;
			var tmp:SimpleButton;
			if (_choosingIndex != -1) {
				tmp = _clearButs[_choosingIndex];
				tmp.mouseEnabled = true;
				tmp.enabled = true;
			}
			trace("test choose clear: " + index);
			_choosingIndex = index;
			tmp = _clearButs[index];
			_choosing.x = tmp.x;
			_choosing.y = tmp.y;
			tmp.mouseEnabled = false;
			tmp.enabled = false;
			
			_clearName.text = _list[_choosingIndex].clear;
		}
		
		/**
		 * 开始播放显示动画
		 */
		public function playShowList():void {
			_clearList.visible = true;
			_clearList.alpha = 0;
			_timer.reset();
			_timer.start();
		}
		/**
		 * 停止播放显示动画
		 */
		public function stopShowList():void {
			_timer.stop();
		}
		private function timerEvent(e:TimerEvent):void {
			_clearList.alpha += 0.1;
		}
		private function showTimerComplete(e:TimerEvent):void {
			startHideList();
		}
		
		/**
		 * 开始隐藏计时
		 */
		public function startHideList():void {
			_hideTimer.reset();
			_hideTimer.start();
		}
		/**
		 * 停止隐藏计时
		 */
		public function stopHideList():void {
			_hideTimer.stop();
		}
		private function hideTimerComplete(e:TimerEvent):void {
			hideList();
		}
		
		/**
		 * 隐藏并停止隐藏计时和显示动画
		 */
		public function hideList():void {
			stopShowList();
			stopHideList();
			_clearList.visible = false;
		}
		
		public function get choosingIndex():int{
			return _choosingIndex;
		}
		
	}

}