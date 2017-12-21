package com.hurrygames.grabber.vo.friend
{
	import com.hurrygames.grabber.vo.BaseVO;
	import com.hurrygames.grabber.vo.UserDataVO;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	import com.hurrygames.grabber.vo.home.HomeVO;
	
	
	/**
	 * Project : LandGrabbers
	 * FriendDetailInfo
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class FriendDetailInfo extends BaseVO
	{
		/**
		 * 好友的信息 
		 */
		public var userInfo:UserDataVO;
		
		/**
		 * 家园的信息。 
		 */
		public var castleInfo:HomeVO;
		
		/**
		 * 此用户的装备。 
		 */
		public var equipmentInfo:Vector.<EquipmentVO> = new Vector.<EquipmentVO>();
		
		public function FriendDetailInfo(o:Object)
		{
			super(o);
		}
	}
} 
