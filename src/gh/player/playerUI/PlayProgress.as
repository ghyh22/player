package gh.player.playerUI {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gh.events.ParaEvent;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/4 11:18
	 **/
	public class PlayProgress extends EventDispatcher {
		public static const JUMP_PROGRESS:String = "jump progress";
		
		private const HEIGHT:Number = 40;
		private const MAX_LEN:Number = 650;
		
		private var _view:Sprite;
		private var _bg:Sprite;
		private var _fg:Sprite;
		private var _playPoint:Sprite;
		private var _playTimeTxt:TextField;
		private var _pointTimeTxt:TextField;
		private var _playTime:Number;
		private var _totalTime:Number;
		private var _totalTimeStr:String;
		public function PlayProgress(view:Sprite) {
			super();
			_view = view;
			_view.mouseChildren = false;
			_view.visible = false;
			_bg = _view.getChildByName("bgMc") as Sprite;
			_bg.alpha = 0;
			_fg = new Sprite();
			_view.addChild(_fg);
			initPlayPoint();
			_playTimeTxt = _view.getChildByName("playTimeMc") as TextField;
			_playTimeTxt.text = "00:00/00:00";
			_playTime = 0;
			_totalTime = 0;
			_totalTimeStr = "0";
			_pointTimeTxt = _view.getChildByName("pointTimeMc") as TextField;
			_pointTimeTxt.text = "00:00";
			_pointTimeTxt.visible = false;
			_pointTimeTxt.mouseEnabled = false;
		}
		private function initPlayPoint():void {
			_playPoint = new Sprite();
			_playPoint.graphics.lineStyle(2, 0x00ffbe);
			_playPoint.graphics.lineTo(0, HEIGHT);
			_view.addChild(_playPoint);
		}
		
		private var _downFlag:Boolean;
		private var _jumpProgress:Function;
		public function start(jump:Function, totalTime:uint, playTime:uint = 0):void {
			LOG.show("PlayProgress.start");
			_jumpProgress = jump;
			_view.visible = true;
			setTotalTime(totalTime);
			setPlayTime(playTime);
			_downFlag = false;
			_view.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_view.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_view.addEventListener(MouseEvent.MOUSE_DOWN, onUp);
		}
		public function close():void {
			LOG.show("PlayProgress.close");
			_view.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_view.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_view.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_view.visible = false;
		}
		private function onMove(e:MouseEvent):void {
			var px:Number = e.localX;
			if (px < MAX_LEN && px > 0) {
				var per:Number = px / MAX_LEN;
				var time:Number = _totalTime * per;
				_pointTimeTxt.x = px - _pointTimeTxt.textWidth / 2;
				_pointTimeTxt.text = makeFormatTime(time);
				_pointTimeTxt.visible = true;
			}else {
				_pointTimeTxt.visible = false;
			}
		}
		private function onOut(e:MouseEvent):void {
			_pointTimeTxt.visible = false;
		}
		private function onUp(e:MouseEvent):void {
			_downFlag = false;
			var px:Number = e.localX;
			if (px < MAX_LEN && px > 0) {
				var per:Number = px / MAX_LEN;
				_jumpProgress(per);
				var len:Number = MAX_LEN * per;
				drawProgress(len);
				_playPoint.x = len;
			}
		}
		
		public function stopDragPlay():void {
			_downFlag = false;
		}
		
		public function setTotalTime(time:uint):void {
			_totalTime = time;
			_totalTimeStr = makeFormatTime(time);
		}
		public function setPlayTime(playTime:Number):void {
			_playTime = playTime;
			var tmp:String = makeFormatTime(playTime);
			_playTimeTxt.text = tmp + "/" + _totalTimeStr;
			var per:Number = _playTime / _totalTime;
			var len:Number = MAX_LEN * per;
			drawProgress(len);
			_playPoint.x = len;
		}
		private function drawProgress(len:Number):void {
			if (len > 0) {
				var g:Graphics = _fg.graphics;
				g.clear();
				g.beginFill(0x13BD92, 0.5);
				g.drawRect(0, 0, len, HEIGHT);
				g.endFill();
			}
		}
		private function makeFormatTime(time:uint):String {
			var s:uint = time % 60;
			var m:uint = Math.floor(time / 60);
			var tmp:String = "";
			if (m < 10) {
				tmp += "0";
			}
			tmp += m + ":";
			if (s < 10) {
				tmp += "0";
			}
			tmp += s;
			return tmp;
		}
		
		public function get view():Sprite{
			return _view;
		}
	}

}