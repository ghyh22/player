package gh.tools {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/8 15:54
	 **/
	public class McButton {
		
		private var _list:Vector.<MovieClip>;
		public function McButton() {
			_list = new Vector.<MovieClip>();
		}
		
		public function addButton(mc:MovieClip):void {
			_list.push(mc);
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			mc.addEventListener(MouseEvent.MOUSE_OVER, onOver);
		}
		public function removeButton(mc:MovieClip):int {
			var index:uint = _list.indexOf(mc);
			if (index >= 0) {
				mc.buttonMode = false;
				mc.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				mc.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				mc.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				mc.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				_list.splice(index, 1);
			}
			return index;
		}
		public function clearButtons():void {
			while (_list.length > 0) {
				var mc:MovieClip = _list.pop();
				mc.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				mc.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				mc.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				mc.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			}
		}
		
		private function onDown(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(3);
			mc.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		private function onOver(e:MouseEvent):void {
			if (e.buttonDown) return;
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(2);
			mc.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		private function onUp(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
			mc.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		private function onOut(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
			mc.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
	}

}