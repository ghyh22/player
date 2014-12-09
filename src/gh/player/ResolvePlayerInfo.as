package gh.player {
	
	/**
	 * @author gonghao
	 * @email yanghaogong@126.com
	 * @date 2014/12/9 16:48
	 * 解析从服务器获取的数据
	 **/
	public class ResolvePlayerInfo {
		public function ResolvePlayerInfo(data:String) {
			
		}
		
		public static function resolvePlayerInfo(data:Object):PlayerInfo {
			var user:PlayerUser = resolveUser(data);
			var chan:VideoChannel = resolveChan(data);
			return new PlayerInfo(user, chan);
		}
		public static function resolveUser(data:Object):PlayerUser {
			var name:String = data["user"]["info"]["Name"];
			var token:String = data["user"]["token"];
			var ipArea:String = data["user"]["ip"]["AreaName"];
			var ipOp:String = data["user"]["ip"]["OpName"];
			var user:PlayerUser = new PlayerUser(name, token, ipArea, ipOp);
			return user;
		}
		public static function resolveChan(data:Object):VideoChannel {
			var chanID:String = data["chan"]["ChanID"];
			var tmpList:Array = data["rtmp"];
			var rtmpList:Vector.<RTMPInfo> = new Vector.<RTMPInfo>();
			for (var i:int = 0; i < tmpList.length; i ++) {
				rtmpList.push(resolveRTMP(tmpList[i]));
			}
			return new VideoChannel(chanID, rtmpList);
		}
		public static function resolveRTMP(data:Object):RTMPInfo {
			var name:String = data["Name"];
			var url:String = data["Url"];
			var stream:String = data["Stream"];
			var cdnID:String = data["CdnID"];
			return new RTMPInfo(name, url, stream, cdnID);
		}
	}

}