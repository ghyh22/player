package gh.player {
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import gh.player.playerUI.PlayerUI;
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/11/27 16:54
	 **/
	public class GN100Video extends EventDispatcher {
		public static const STATUS_CHANG:String = "video status change";
		//stream运行状态
		public static const STARTING:String = "STARTING";
		public static const STARTED:String = "STARTED";
		public static const STOPPING:String = "STOPPING";
		public static const STOPPED:String = "STOPPED";
		public static const PAUSED:String = "PAUSED";
		
		private var _video:Video;
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _remoting:Boolean;
		private var _state:String;
		private var _playing:Boolean;
		public function GN100Video(w:Number = 800, h:Number = 600) {
			_video = new Video(w, h);
			_remoting = false;
			_playing = false;
			updateStreamStatus(STOPPED);
		}
		
		private var _info:RTMPInfo;
		public function start(info:RTMPInfo):void {
			connect(info);
		}
		public function closed():void {
			closeConnection();
		}
		
		public function connect(info:RTMPInfo):void {
			if (_connection != null && _connection.connected) {
				LOG.show("前一个NetConnection未断开.");
				return;
			}
			if (info != null) {
				if (info.url == null) {
					_remoting = false;
				} else {
					_remoting = true;
				}
				_info = info;
				_connection = new NetConnection();
				_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				
				LOG.show("Connecting: " + _info.url);
				_connection.connect(_info.url);
			}
		}
		public function closeConnection():void {
			if (_connection != null && _connection.connected) {
				streamClose();
				
				_connection.close();
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_connection = null;
			}
		}
		private function netStatusHandler(event:NetStatusEvent):void {
			LOG.show(event.info.code);
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
					streamStart();
					dispatchEvent(new Event(STATUS_CHANG));
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + _info.url);
                    break;
				case "NetConnection.Connect.Failed":
					
					break;
				case "NetStream.Connect.Closed":
					streamClose();
					break;
				case "NetStream.Play.Start":
					playStartHandle();
					break;
				case "NetStream.Play.Stop":
					closePlay();
					_streamTime = 0;
					break;
				case "NetStream.Buffer.Flush":
					if (_state == STOPPING) {
						playStopHandle();
					}
					break;
            }
        }
		private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
			LOG.show(event.type);
        }
		private function asyncErrorHandle(e:AsyncErrorEvent):void {
			LOG.show(e.error.message);
		}
		
		private function streamStart():void {
			_stream = new NetStream(_connection);
			_stream.inBufferSeek = false;
			if (_remoting) {
				_stream.bufferTime = 0;
			} else {
				_stream.bufferTime = 1;
			}
			_stream.bufferTimeMax = 0;
			
			_stream.maxPauseBufferTime = 30;
			_stream.backBufferTime = 30;
			_video.attachNetStream(_stream);
			_video.smoothing = true;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandle);
			_stream.client = new StreamClient();
			//startPlay();
		}
		private function streamClose():void {
			if (_stream != null) {
				closePlay();
				
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandle);
				_stream = null;
				updateStreamStatus(STOPPED);
			}
		}
		
		private function playStartHandle():void {
			updateStreamStatus(STARTED);
			dispatchEvent(new Event(STATUS_CHANG));
		}
		private function playStopHandle():void {
			updateStreamStatus(STOPPED);
			dispatchEvent(new Event(STATUS_CHANG));
		}
		
		private var _streamTime:Number;
		public function startPlay():void {
			if (_info.stream != null && _stream != null) {
				if (_state == STOPPED) {
					_playing = true;
					updateStreamStatus(STARTING);
					dispatchEvent(new Event(STATUS_CHANG));
					LOG.show("start play: " + _info.stream);
					_stream.play(_info.stream, 0);
				} else if (_state == PAUSED) {
					LOG.show("unpause");
					_stream.seek(_streamTime);
					_stream.resume();
					updateStreamStatus(STARTED);
					dispatchEvent(new Event(STATUS_CHANG));
				}
			} else {
				LOG.show("error", "streamPath or stream = null");
			}
		}
		public function closePlay():void {
			if (_stream != null && _state == STARTED) {
				_playing = false;
				updateStreamStatus(STOPPING);
				dispatchEvent(new Event(STATUS_CHANG));
				_stream.close();
			}
		}
		public function pausePlay():void {
			if (_stream != null && _state == STARTED) {
				if (_remoting) {
					_playing = false;
					updateStreamStatus(STOPPING);
					dispatchEvent(new Event(STATUS_CHANG));
					_stream.close();
				} else {
					updateStreamStatus(PAUSED);
					dispatchEvent(new Event(STATUS_CHANG));
					_streamTime = _stream.time;
					_stream.pause();
				}
			}
		}
		/**
		 * 音量控制
		 * @param	volume
		 */
		public function soundVolume(volume:Number):void {
			if (_stream != null) {
				var sound:SoundTransform = _stream.soundTransform;
				var tmp:Number = sound.volume + volume;
				if (tmp > 1) {
					tmp = 1;
				} else if(tmp < 0) {
					tmp = 0;
				}
				sound.volume = tmp;
				_stream.soundTransform = sound;
				LOG.show("volume:" + sound.volume);
			}
		}
		/**
		 * 静音控制
		 */
		private var _oldVolume:Number = -1;
		public function mute():void {
			if (_stream != null) {
				var sound:SoundTransform = _stream.soundTransform;
				if (_oldVolume != -1) {
					sound.volume = _oldVolume;
					_oldVolume = -1;
				} else {
					_oldVolume = sound.volume;
					sound.volume = 0;
				}
				_stream.soundTransform = sound;
				LOG.show("volume:" + sound.volume);
			}
		}
		
		/**
		 * 更新NetStream状态
		 * @param	state
		 */
		private function updateStreamStatus(state:String):void {
			_state = state;
			LOG.show(state);
		}
		
		public function get video():Video {
			return _video;
		}
		public function get connected():Boolean {
			return _connection != null && _connection.connected;
		}
		public function get playing():Boolean {
			return _playing;
		}
		
		public function get playInfo():RTMPInfo{
			return _info;
		}
		
		public function get state():String{
			return _state;
		}
		
		public function get remoting():Boolean{
			return _remoting;
		}
		
		public function get stream():NetStream{
			return _stream;
		}
		
	}

}

class StreamClient {
	public function onMetaData(info:Object):void {
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }
    public function onCuePoint(info:Object):void {
        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }
	public function onPlayStatus(info:Object):void {
		trace("playstatus: ");
	}
}