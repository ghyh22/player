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
		public static var EXTERNALCALL:ExternalCall = null;
		public static var RESOURCE:ResourceManager = null;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			initLayers();
			inits();
			loadElements();
		}
		private var _topLayer:Sprite;
		private var _bottomLayer:Sprite;
		private var _middleLayer:Sprite;
		private function initLayers():void
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			_bottomLayer = new Sprite();
			addChild(_bottomLayer);
			_middleLayer = new Sprite();
			addChild(_middleLayer);
			_topLayer = new Sprite();
			addChild(_topLayer);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
			}else if (e.keyCode == Keyboard.R) {
				if (RESOURCE.running) {
					RESOURCE.close();
				}else {
					RESOURCE.start();
				}
			}else if (e.keyCode == Keyboard.C) {
				LOG.appFlag = !LOG.appFlag;
			}
		}
		private function inits():void
		{
			LOG.initLog(_topLayer);
			//LOG.sd();
			RESOURCE = new ResourceManager(_topLayer);
			RESOURCE.start();
			SWFCONFIG = new SwfConfig(stage.loaderInfo.parameters);
			LOG.show("SwfConfig: " + SWFCONFIG.toString());
			MCBUTTON = new McButton();
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
			
			startUp();
		}
		private function startUp():void {
			requestInfo();
		}
		
		private function requestInfo():void {
			var url:String;
			if (SWFCONFIG.playInfoURL != null) {
				url = SWFCONFIG.playInfoURL;
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
		private var _playerInfo:PlayerInfo;
		private function playerStart(playerInfo:PlayerInfo = null):void {
			LOG.show("palyer start");
			if (playerInfo == null && _playerInfo == null) {
				LOG.show("使用本地视频测试.");
				var infoList:Vector.<RTMPInfo> = Vector.<RTMPInfo>([
													new RTMPInfo("超清", null, "D:/video/nw.mp4"),
													new RTMPInfo("高清", null, "D:/video/nw.mp4"),
													new RTMPInfo("标清", null, "D:/video/nw.mp4"),
													//new RTMPInfo("超清", "rtmp://121.42.56.177/live", "xxx"),
													//new RTMPInfo("高清", "rtmp://121.42.56.177/live", "xxx"),
													//new RTMPInfo("标清", "rtmp://121.42.56.177/live", "xxx"),
													//new RTMPInfo("超清", null, "http://www.helpexamples.com/flash/video/cuepoints.flv")
													]);
				var chan:VideoChannel = new VideoChannel("0", infoList);
				var user:PlayerUser = new PlayerUser("0", "test token");
				_playerInfo = new PlayerInfo(user, chan);
			}
			else if(playerInfo != null) {
				_playerInfo = playerInfo;
			}
			
			_player = new GN100Player(stage.stageWidth, stage.stageHeight);
			_bottomLayer.addChild(_player);
			_player.start(_playerInfo.chan, SWFCONFIG.autoPlay, SWFCONFIG.clear, SWFCONFIG.playPer);
		}
		private function playerClosed():void {
			LOG.show("player closed");
			if (_player != null) {
				_player.closed();
				_bottomLayer.removeChild(_player);
				_player = null;
			}
		}
		
	}
	
}