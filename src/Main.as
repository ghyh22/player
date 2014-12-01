package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import gh.element.util.ElementCreater;
	import gh.element.util.ELL;
	import gh.element.util.LoadManager;
	import gh.player.GN100Player;
	import gh.player.PlayerUser;
	import gh.player.RTMPInfo;
	import gh.player.VideoChannel;
	
	/**
	  * @author gonghao
	  * @email yanghaogong@126.com
	  * @date 2014/11/27 15:21
	  **/
	 
	[SWF(width="852",height="480",frameRate="24",backgroundColor="#333333")]
	//[SWF(width="640",height="360",frameRate="24",backgroundColor="#333333")]
	//[SWF(width="426",height="240",frameRate="24",backgroundColor="#333333")]
	public class Main extends Sprite {
		
		public static var EC:ElementCreater = null;
		
		private var _topLayer:Sprite;
		private var _bottomLayer:Sprite;
		private var _middleLayer:Sprite;
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			inits();
			loadElements();
		}
		private function inits():void
		{
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			initLayers();
			LOG.initLog(_topLayer);
			LOG.sd();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		private function initLayers():void
		{
			_bottomLayer = new Sprite();
			addChild(_bottomLayer);
			_middleLayer = new Sprite();
			addChild(_middleLayer);
			_topLayer = new Sprite();
			addChild(_topLayer);
		}
		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.X) {
				playerClosed();
			} else if (e.keyCode == Keyboard.Z) {
				if (_player == null) {
					playerStart();
				}
			} else if (e.keyCode == Keyboard.L) {
				LOG.sd();
			} else if (e.keyCode == Keyboard.C) {
				changeClear();
			}
		}
		private function loadElements():void
		{
			var loader:LoadManager = new LoadManager(new ELL());
			LOG.show("load element: " + loader.files.length);
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.load();
		}
		private function loadComplete(e:Event):void 
		{
			var loader:LoadManager = e.currentTarget as LoadManager;
			EC = new ElementCreater(loader)
			loader.removeEventListener(Event.COMPLETE, loadComplete);
			
			playerStart();
		}
		
		private var _chan:VideoChannel;
		private var _user:PlayerUser;
		private var _player:GN100Player;
		private function playerStart():void {
			var infoList:Vector.<RTMPInfo> = Vector.<RTMPInfo>([
												new RTMPInfo("超清", "rtmp://182.92.168.238/live", "xxx_hi"),
												new RTMPInfo("高清", "rtmp://182.92.168.238/live", "xxx_mid"),
												new RTMPInfo("标清", "rtmp://182.92.168.238/live", "xxx_low")
												]);
			_chan = new VideoChannel("0", infoList);
			_user = new PlayerUser("0", "test token");
			_player = new GN100Player(stage.stageWidth, stage.stageHeight);
			_bottomLayer.addChild(_player);
			_player.start(_chan);
			LOG.show("clear num: " + infoList.length);
		}
		private function playerClosed():void {
			if (_player != null) {
				_player.closed();
				removeChild(_player);
				_player = null;
			}
		}
		
		private function changeClear():void {
			_player.changleClear();
		}
	}
	
}