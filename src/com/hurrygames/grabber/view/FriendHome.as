package com.hurrygames.grabber.view
{
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.vo.friend.FriendDetailInfo;
	
	import flash.events.Event;
	
	
	/**
	 * Project : LandGrabbers
	 * FriendHome
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class FriendHome extends Home
	{
		protected var $friendData:FriendDetailInfo;
		
		public function FriendHome()
		{
			super();
			if(this.stage != null)
			{
				init()
			}else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,init1);
			}
		}
		
		public function installData(friendDetail:FriendDetailInfo):void
		{
			$friendData = friendDetail;
			initCastale(friendDetail.castleInfo);
			installRoleData(friendDetail.equipmentInfo);
		}
		
		public function destory1(e:Event = null):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,destory1);
		}
		
		public function init1(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init1);
			this.addEventListener(Event.REMOVED_FROM_STAGE,destory1);
		}
		
		
	}
} 
