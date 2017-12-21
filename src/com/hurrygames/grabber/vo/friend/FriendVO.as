package com.hurrygames.grabber.vo.friend
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	/**
	 * Project : LandGrabbers
	 * FriendVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class FriendVO extends BaseVO
	{
		/**
		 *名字 
		 */		
		public var name:String;
		/**
		 *头像 
		 */		
		public var imgurl:String;
		/**
		 *是否是某一关的擂主。如果是为1，不是为0. 
		 */		
		public var isMaster:int;
		
		/**
		 *用户的等级 
		 */
		public var level:int;
		
		/**
		 *用户的id 
		 */
		public var fid:int;
		
		public function FriendVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
