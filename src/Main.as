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
	import gh.player.PlayerInfo;
	import gh.player.PlayerUser;
	import gh.player.RequestPlayerInfo;
	import gh.player.RTMPInfo;
	import gh.player.VideoChannel;
	import gh.tools.McButton;
	
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
		public static var MCBUTTON:McButton = null;
		public static var SWFCONFIG:SwfConfig = null;
		
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
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			initLayers();
			LOG.initLog(_topLayer);
			LOG.sd();
			SWFCONFIG = new SwfConfig(stage.loaderInfo.parameters);
			MCBUTTON = new McButton();
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
			} else if (e.keyCode == Keyboard.P) {
				LOG.showAppStep();
			}else if (e.keyCode == Keyboard.C) {
				LOG.appFlag = !LOG.appFlag;
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
			
			requestInfo();
		}
		
		private function requestInfo():void {
			var url:String;
			if (SWFCONFIG.playInfo != null) {
				url = SWFCONFIG.playInfo;
				LOG.show("playInfo from config");
			}
			else {
				url = "http://api.gn100.com/player.chan.info";
				LOG.show("playInfo from this");
			}
			if (url != null) {
				var request:RequestPlayerInfo = new RequestPlayerInfo(url);
				request.start(playerStart);
			}
			else {
				playerStart();
			}
		}
		
		private var _player:GN100Player;
		private function playerStart(playerInfo:PlayerInfo = null):void {
			LOG.show("palyer start");
			if (playerInfo == null) {
				var infoList:Vector.<RTMPInfo> = Vector.<RTMPInfo>([
													new RTMPInfo("超清", null, "D:/video/nw.mp4"),
													//new RTMPInfo("超清", "rtmp://121.42.56.177/live", "xxx"),
													new RTMPInfo("高清", "rtmp://121.42.56.177/live", "xxx"),
													new RTMPInfo("标清", "rtmp://121.42.56.177/live", "xxx"),
													//new RTMPInfo("超清", null, "http://www.helpexamples.com/flash/video/cuepoints.flv")
													]);
				var chan:VideoChannel = new VideoChannel("0", infoList);
				var user:PlayerUser = new PlayerUser("0", "test token");
				playerInfo = new PlayerInfo(user, chan);
			}
			
			_player = new GN100Player(stage.stageWidth, stage.stageHeight);
			_bottomLayer.addChild(_player);
			_player.start(playerInfo.chan, SWFCONFIG.autoPlay);
			LOG.show("clear num: " + playerInfo.chan.list.length);
		}
		private function playerClosed():void {
			if (_player != null) {
				_player.closed();
				removeChild(_player);
				_player = null;
			}
		}
		
	}
	
}