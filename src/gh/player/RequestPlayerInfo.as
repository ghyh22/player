package gh.player {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/9 17:20
	 **/
	public class RequestPlayerInfo {
		private var _url:URLRequest;
		private var _loader:URLLoader;
		private var _playerInfo:PlayerInfo;
		public function RequestPlayerInfo(url:String) {
			_url = new URLRequest(url);
			_loader = new URLLoader();
		}
		
		private var _receive:Function;
		public function start(fun:Function):void {
			_receive = fun;
			_loader.addEventListener(Event.COMPLETE, loaderComplete);
			_loader.load(_url);
		}
		public function close():void {
			LOG.show("request closed");
			_receive = null;
			_loader.close();
			_loader.removeEventListener(Event.COMPLETE, loaderComplete);
		}
		private function loaderComplete(e:Event):void {
			var data:Object = JSON.parse(_loader.data);
			_playerInfo = ResolvePlayerInfo.resolvePlayerInfo(data);
			_receive(_playerInfo);
			close();
		}
		
		public function get playerInfo():PlayerInfo{
			return _playerInfo;
		}
	}

}