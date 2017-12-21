package com.hurrygames.grabber.ui.controller
{
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.utils.ServerCall;
	import com.hurrygames.grabber.vo.friend.FriendDetailInfo;
	import com.hurrygames.grabber.vo.friend.FriendsVO;
	
	import flash.net.URLVariables;

	public class FriendController
	{
		
		private static var _instance:FriendController;
		
		/**
		 * 好友数据列表 
		 */		
		public var friends:FriendsVO;
		
		public static function get instance():FriendController
		{
			if(_instance == null)
			{
				_instance = new FriendController();
			}
			return _instance;
		}
		public function FriendController()
		{
			if(_instance != null)
			{
				throw new Error("FriendController 是单例类。");
			}
		}
		
		/**
		 * 获取好友信息 
		 * @param callBack
		 * 
		 */
		public function getFriend(callBack:Function):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_FRIEND_LIST,function(result:Object):void
			{
				if(result.code == 1)
				{
					friends = new FriendsVO(result.data);
					callBack(friends);
				}
			});
		}
		
		/**
		 * 获取好友的具体信息，用于去好友家。 
		 * @param friendId
		 * @param callBack 接受一个 FriendDetailInfo作为参数
		 * 
		 */
		public function getFriendDetailInfo(friendId:int,callBack:Function):void
		{
			var variable:URLVariables = new URLVariables();
			variable.fid = friendId;
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_FRIEND_INFO,function(result:Object):void
			{
				if(result.code == 1)
				{
					trace("好友信息:"+result.data.toString());
					var friend:FriendDetailInfo = new FriendDetailInfo(result.data);
					callBack(friend);
				}
			},variable);
		}
	}
}