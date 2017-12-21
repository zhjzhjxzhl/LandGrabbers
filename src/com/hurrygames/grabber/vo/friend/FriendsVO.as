package com.hurrygames.grabber.vo.friend
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * FriendsVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class FriendsVO extends BaseVO
	{
		public var friends:Vector.<FriendVO> = new Vector.<FriendVO>();
		
		public function FriendsVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
