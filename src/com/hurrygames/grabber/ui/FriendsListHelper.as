package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.ui.controller.FriendController;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.utils.ListDataHelper;
	import com.hurrygames.grabber.utils.WindowManager;
	import com.hurrygames.grabber.vo.friend.FriendDetailInfo;
	import com.hurrygames.grabber.vo.friend.FriendVO;
	import com.hurrygames.grabber.vo.friend.FriendsVO;
	import com.hurrygames.landgrabber.swc.HomeUI.FriendList;
	import com.hurrygames.landgrabber.swc.HomeUI.OneFriendRender;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import gs.TweenLite;
	
	public class FriendsListHelper extends BaseObject
	{
		private var _friendList:FriendList;
		
		private var _list:ListDataHelper;
		
		/**
		 *好友列表好友个数 
		 */
		private static const RENDERNUM:int = 8;
		
		public function FriendsListHelper()
		{
			super();
			_friendList = new FriendList();
			_friendList.x = 1.85;
			_friendList.y = 503.80;
			this.addChild(_friendList);
		}
		
		override protected function destory():void
		{
			super.destory();
			clearMyInfo();
			clearFriends();
			destoryListeners();
		}
		
		override protected function init():void
		{
			super.init();
			if(FriendController.instance.friends == null)
			{
				FriendController.instance.getFriend(initFriendsData);
			}else
			{
				initFriendsData(FriendController.instance.friends);
			}
			initMyInfo();
			initListeners();
		}
		
		private function initMyInfo():void
		{
			_friendList.mc_myInfo.txt_userName.text = UserProfile.instance.userData.name;
			_friendList.mc_myInfo.txt_userLevel.text = UserProfile.instance.userData.level.toString();
			var head:Sprite = new Sprite();
			head.name = "headIcon";
			head.x = 7;
			head.y = 14;
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest(UserProfile.instance.userData.imgurl));
//			head.addChild(loader);
			_friendList.mc_myInfo.addChild(head);
		}
		
		private function initFriendsData(friends:FriendsVO):void
		{
			var arr:Array = []
			_list = new ListDataHelper(friends.friends,RENDERNUM);
			installFriends(_list.rollNext(0,null,false));
		}
		
		private function installFriends(friends:Array):void
		{
			clearFriends();
			for(var i:int = 0;i<friends.length;i++)
			{
				if(i>=RENDERNUM)
				{
					break;
				}
				var render:OneFriendRender = _friendList["mc_friendRender"+i] as OneFriendRender;
				render.txt_userName.text = (friends[i] as FriendVO).name;
				render.txt_userLevel.text = (friends[i] as FriendVO).level.toString();
				
				var head:Sprite = new Sprite();
				head.name = "headIcon";
				head.x = 7;
				head.y = 14;
				var loader:Loader = new Loader();
				loader.load(new URLRequest((friends[i] as FriendVO).imgurl));
				head.addChild(loader);
				render.addChild(head);
				render.friendId = (friends[i] as FriendVO).fid;
			}
			refreshPageRoll();
		}
		
		private function clearFriends():void
		{
			for(var i:int = 0;i<RENDERNUM;i++)
			{
				var render:OneFriendRender = _friendList["mc_friendRender"+i] as OneFriendRender;
				var c:DisplayObject = render.getChildByName("headIcon");
				if(c != null)
				{
					render.removeChild(c);
					delete render.friendId;
				}
				render.txt_userLevel.text="";
				render.txt_userName.text="";
			}
		}
		
		private function clearMyInfo():void
		{
			var render:OneFriendRender = _friendList.mc_myInfo;
			var c:DisplayObject = render.getChildByName("headIcon");
			if(c != null)
			{
				render.removeChild(c);
			}
			render.txt_userLevel.text="";
			render.txt_userName.text="";
		}
		
		private function initListeners():void
		{
			_friendList.btn_buttonLeft.addEventListener(MouseEvent.CLICK,rollLeft);
			_friendList.btn_buttonRight.addEventListener(MouseEvent.CLICK,rollRight);
			_friendList.btn_FriendListHide.addEventListener(MouseEvent.CLICK,hide);
			_friendList.btn_FriendListShow.addEventListener(MouseEvent.CLICK,show);
			
			for(var i:int = 0;i<RENDERNUM;i++)
			{
				var render:OneFriendRender = _friendList["mc_friendRender"+i] as OneFriendRender;
				render.addEventListener(MouseEvent.CLICK,goFriendHome);
			}
			_friendList.mc_myInfo.addEventListener(MouseEvent.CLICK,goHome);
			
		}
		
		protected function goHome(event:MouseEvent):void
		{
			MainUIController.instance.setMode(MainUIController.HOME_UI);
		}
		
		protected function goFriendHome(event:MouseEvent):void
		{
			var render:OneFriendRender = event.currentTarget as OneFriendRender;
			if(render.hasOwnProperty("friendId"))
			{
				var friendId:int = render.friendId;
				//在这里获取好友的信息，并且去好友家.
				FriendController.instance.getFriendDetailInfo(friendId,gotFriendDetailInfo);
			}
		}
		
		private function gotFriendDetailInfo(detailInfo:FriendDetailInfo):void
		{
			MainUIController.instance.setMode(MainUIController.FRIEND_HOME,detailInfo);
		}
		
		protected function show(event:MouseEvent):void
		{
			TweenLite.to(_friendList,0.3,{y:503.80});
			_friendList.btn_FriendListShow.visible = false;
			_friendList.btn_FriendListHide.visible = true;
		}
		
		protected function hide(event:MouseEvent):void
		{
			TweenLite.to(_friendList,0.3,{y:580});
			_friendList.btn_FriendListShow.visible = true;
			_friendList.btn_FriendListHide.visible = false;
		}
		
		protected function rollRight(event:MouseEvent):void
		{
			installFriends(_list.rollNext(RENDERNUM,null,false));
		}
		
		protected function rollLeft(event:MouseEvent):void
		{
			installFriends(_list.rollNext(-RENDERNUM,null,false));
		}
		
		private function refreshPageRoll():void
		{
			if(_list == null)
			{
				WindowManager.disableDisplayObject(_friendList.btn_buttonLeft,true);
				WindowManager.disableDisplayObject(_friendList.btn_buttonRight,true);
			}else
			{
				WindowManager.disableDisplayObject(_friendList.btn_buttonLeft,_list.atBegin());
				WindowManager.disableDisplayObject(_friendList.btn_buttonRight,_list.atEnd());
			}
		}
		
		private function destoryListeners():void
		{
			_friendList.btn_buttonLeft.removeEventListener(MouseEvent.CLICK,rollLeft);
			_friendList.btn_buttonRight.removeEventListener(MouseEvent.CLICK,rollRight);
			_friendList.btn_FriendListHide.removeEventListener(MouseEvent.CLICK,hide);
			_friendList.btn_FriendListShow.removeEventListener(MouseEvent.CLICK,show);
			
			for(var i:int = 0;i<RENDERNUM;i++)
			{
				var render:OneFriendRender = _friendList["mc_friendRender"+i] as OneFriendRender;
				render.removeEventListener(MouseEvent.CLICK,goFriendHome);
			}
			_friendList.mc_myInfo.removeEventListener(MouseEvent.CLICK,goHome);
		}
		
	}
}