package  {
	import flash.external.ExternalInterface;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/10 10:40
	 * 外部功能调用
	 **/
	public class ExternalCall {
		public static const ec:ExternalCall = new ExternalCall();
		
		public function ExternalCall() {
			
		}
		
		public function addPlayer(play:Function, pause:Function, stop:Function, progress:Function, mute:Function, unmute:Function, clear:Function):void {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("playerPlay", play);
				ExternalInterface.addCallback("playerPause", pause);
				ExternalInterface.addCallback("playerStop", stop);
				ExternalInterface.addCallback("playerProgress", progress);
				ExternalInterface.addCallback("playerMute", mute);
				ExternalInterface.addCallback("playerUnmute", unmute);
				ExternalInterface.addCallback("playerClear", clear);
			}
		}
		public function removePlayer():void {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("playerPlay", null);
				ExternalInterface.addCallback("playerPause", null);
				ExternalInterface.addCallback("playerStop", null);
				ExternalInterface.addCallback("playerProgress", null);
				ExternalInterface.addCallback("playerMute", null);
				ExternalInterface.addCallback("playerUnmute", null);
				ExternalInterface.addCallback("playerClear", null);
			}
		}
	}

}