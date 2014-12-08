package gh.player.playerUI {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import gh.events.ParaEvent;
	import gh.player.GN100Player;
	import gh.player.RTMPInfo;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/2 10:52
	 **/
	public class ClearManager extends EventDispatcher {
		public static const CLEAR_CHANGE:String = "clear changed";
		
		public static const CLEAR_MAX_LEN:uint = 3;
		
		private var _choosingClear:String;
		private var _choosingView:Sprite;
		private var _choosingList:Vector.<SimpleButton>;
		private var _listView:Sprite;
		private var _clearList:Vector.<MovieClip>;
		private var _list:Vector.<String>;
		private var _choosingBox:Sprite;
		private var _timer:Timer;
		private var _hideTimer:Timer;
		public function ClearManager(choosingView:Sprite, listView:Sprite) {
			_choosingView = choosingView;
			_listView = listView;
			initClearList();
			_timer = new Timer(30, 10);
			_hideTimer = new Timer(2000, 1);
			initStatus();
		}
		private function initClearList():void {
			_list = new Vector.<String>(CLEAR_MAX_LEN);
			_clearList = new Vector.<MovieClip>(CLEAR_MAX_LEN);
			_choosingList = new Vector.<SimpleButton>(CLEAR_MAX_LEN);
			
			_list[0] = GN100Player.SD;
			var tmp:SimpleButton;
			var mc:MovieClip = _listView.getChildByName("sdMc") as MovieClip;
			_clearList[0] = mc; 
			tmp = _choosingView.getChildByName("sdMc") as SimpleButton;
			_choosingList[0] = tmp;
			
			_list[1] = GN100Player.HD;
			mc = _listView.getChildByName("hdMc") as MovieClip;
			_clearList[1] = mc;
			tmp = _choosingView.getChildByName("hdMc") as SimpleButton;
			_choosingList[1] = tmp;
			
			_list[2] = GN100Player.BD;
			mc = _listView.getChildByName("bdMc") as MovieClip;
			_clearList[2] = mc;
			tmp = _choosingView.getChildByName("bdMc") as SimpleButton;
			_choosingList[2] = tmp;
			
			_choosingBox = _listView.getChildByName("choosingBoxMc") as Sprite;
		}
		private function initStatus():void {
			_choosingClear = null;
			_choosingView.visible = false;
			_listView.visible = false;
			for (var i:int = 0; i < CLEAR_MAX_LEN; i ++) {
				var mc:MovieClip = _clearList[i];
				mc.enabled = false;
				mc.mouseEnabled = false;
				mc.alpha = 0.5;
				mc.gotoAndStop(1);
				
				var tmp:SimpleButton = _choosingList[i];
				tmp.visible = false;
			}
		}
		
		private var _clearChange:Function;
		public function start(clearList:Vector.<RTMPInfo>, change:Function):void {
			LOG.addStep("Clear.start");
			_clearChange = change;
			_choosingView.visible = true;
			for (var i:int = 0; i < clearList.length; i ++) {
				var tmp:RTMPInfo = clearList[i];
				switch(tmp.name) {
					case GN100Player.SD:
						clearEnabled(0);
						break;
					case GN100Player.HD:
						clearEnabled(1);
						break;
					case GN100Player.BD:
						clearEnabled(2);
						break;
				}
			}
			_choosingView.addEventListener(MouseEvent.CLICK, showClearList);
			_timer.addEventListener(TimerEvent.TIMER, timerEvent);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, showTimerComplete);
			_hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideTimerComplete);
			_listView.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_listView.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		private function clearEnabled(index:uint):void {
			var but:MovieClip = _clearList[index];
			Main.MCBUTTON.addButton(but);
			but.alpha = 1;
			but.mouseEnabled = true;
			but.enabled = true;
			but.addEventListener(MouseEvent.CLICK, chooseClearBut);
		}
		public function close():void {
			LOG.addStep("Clear.close");
			hideList();
			for (var i:int = 0; i < _list.length;i ++) {
				var but:MovieClip = _clearList[i];
				Main.MCBUTTON.removeButton(but);
				but.removeEventListener(MouseEvent.CLICK, chooseClearBut);
			}
			_choosingView.removeEventListener(MouseEvent.CLICK, showClearList);
			_timer.removeEventListener(TimerEvent.TIMER, timerEvent);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideTimerComplete);
			_hideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideTimerComplete);
			_listView.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_listView.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			initStatus();
		}
		private function showClearList(e:MouseEvent):void {
			if (_listView.visible) {
				hideList();
			}else {
				playShowList();
			}
		}
		private function chooseClearBut(e:MouseEvent):void {
			var index:uint = _clearList.indexOf(e.currentTarget as MovieClip);
			_clearChange(_list[index]);
			_listView.visible = false;
		}
		private function onOver(e:MouseEvent):void {
			stopHideList();
		}
		private function onOut(e:MouseEvent):void {
			startHideList();
		}
		
		public function chooseClear(name:String):void {
			if (_choosingClear == name) return;
			var mc:MovieClip;
			var index:uint;
			if (_choosingClear != null) {
				index = _list.indexOf(_choosingClear);
				mc = _clearList[index];
				mc.gotoAndStop(1);
				mc.mouseEnabled = true;
				mc.enabled = true;
				_choosingList[index].visible = false;
			}
			_choosingClear = name;
			index = _list.indexOf(name);
			mc = _clearList[index];
			mc.mouseEnabled = false;
			mc.enabled = false;
			mc.gotoAndStop(3);
			_choosingBox.x = mc.x;
			_choosingBox.y = mc.y;
			_choosingList[index].visible = true;
		}
		
		/**
		 * 开始播放显示动画
		 */
		public function playShowList():void {
			_listView.visible = true;
			_listView.alpha = 0;
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
			_listView.alpha += 0.1;
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
			_listView.visible = false;
		}
		
		public function get choosingClear():String{
			return _choosingClear;
		}
	}

}