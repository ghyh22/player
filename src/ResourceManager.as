package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/10 17:45
	 **/
	public class ResourceManager {
		private var _text:TextField;
		private var _container:Sprite;
		public function ResourceManager(container:Sprite) {
			_container = container;
			_text = new TextField();
			_text.width = 200;
			_text.height = 150;
			_text.border = true;
			_text.background = true;
			_text.x = _container.stage.stageWidth - _text.width;
			_text.y = 0;
		}
		
		private var _time:Number;
		private var _count:uint;
		private var _maxFrame:uint;
		private var _fps:Number;
		public function start():void {
			if (running) return;
			_container.addChild(_text);
			_fps = 0;
			_count = 0;
			_maxFrame = 30;
			var date:Date = new Date();
			_time = date.time;
			_container.addEventListener(Event.ENTER_FRAME, run);
		}
		public function close():void {
			if (running) {
				_container.removeChild(_text);
				_container.removeEventListener(Event.ENTER_FRAME, run);
			}
		}
		private function run(e:Event):void {
			if (_count >= _maxFrame) {
				var date:Date = new Date();
				var dt:Number = date.time - _time;
				_fps = _count / dt * 1000;
				showInfo();
				_time = date.time;
				_count = 0;
			}
			else {
				_count ++;
			}
		}
		
		private function showInfo():void {
			var str:String = "fps: " + _fps.toFixed(0) + "\n";
			var memory:Number = System.totalMemoryNumber / 1024 / 1024;
			str += "memory: " + memory.toFixed(2) + "\n";
			memory = System.privateMemory / 1024 / 1024;
			str += "total memory: " + memory.toFixed(2);
			_text.text = str;
		}
		
		public function get fps():Number{
			return _fps;
		}
		public function get running():Boolean {
			return _container.contains(_text);
		}
	}

}