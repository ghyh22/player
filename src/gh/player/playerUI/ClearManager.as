package gh.player.playerUI {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gh.player.RTMPInfo;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/2 10:52
	 **/
	public class ClearManager {
		private var _list:Vector.<RTMPInfo>;
		private var _choosingIndex:uint;
		private var _clear:SimpleButton;
		private var _clearList:Sprite;
		private var _clearName:TextField;
		private var _clearButs:Vector.<SimpleButton>;
		private var _txtList:Vector.<TextField>;
		private var _choosing:Sprite;
		public function ClearManager(clear:SimpleButton, clearList:Sprite) {
			_choosingIndex = 0;
			_clear = clear;
			_clearList = clearList;
			_clearList.visible = false;
			_clearButs = new Vector.<SimpleButton>();
			_txtList = new Vector.<TextField>();
			_choosing = _clearList.getChildByName("choosingMc") as Sprite;
			init();
		}
		private function init():void {
			var len:uint = 4;
			for (var i:int = 0; i < len; i ++) {
				var tmp:DisplayObject = _clearList.getChildByName("clear" + i + "Mc");
				_clearButs.push(SimpleButton(tmp));
				tmp = _clearList.getChildByName("clearTxt" + i + "Mc");
				TextField(tmp).mouseEnabled = false;
				_txtList.push(TextField(tmp));
			}
		}
		
		public function start(clearList:Vector.<RTMPInfo>):void {
			_list = clearList;
			for (var i:int = 0; i < _txtList.length; i ++) {
				var txt:TextField = _txtList[i];
				if (i < _list.length) {
					txt.text = _list[i].clear;
					var but:SimpleButton = _clearButs[i];
					but.addEventListener(MouseEvent.CLICK, chooseClearBut);
				}else {
					txt.text = "无";
				}
			}
			_clear.addEventListener(MouseEvent.CLICK, showClearList);
		}
		public function close():void {
			for (var i:int = 0; i < _list.length;i ++) {
				var but:SimpleButton = _clearButs[i];
				but.removeEventListener(MouseEvent.CLICK, chooseClearBut);
			}
			_clear.removeEventListener(MouseEvent.CLICK, showClearList);
		}
		private function showClearList(e:MouseEvent):void {
			_clearList.visible = !_clearList.visible;
		}
		private function chooseClearBut(e:MouseEvent):void {
			var index:uint = _clearButs.indexOf(e.currentTarget as SimpleButton);
			chooseClear(index);
		}
		
		public function chooseClear(index:uint):void {
			if (index < _list.length) {
				_choosingIndex = index;
				var tmp:SimpleButton = _clearButs[index];
				_choosing.x = tmp.x;
				_choosing.y = tmp.y;
				
				_clearName.text = choosingClear.clear;
			}
		}
		
		public function get choosingClear():RTMPInfo{
			return _list[_choosingIndex];
		}
		
		
	}

}