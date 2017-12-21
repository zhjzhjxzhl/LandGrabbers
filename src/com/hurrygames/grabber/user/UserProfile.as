package com.hurrygames.grabber.user
{
	import com.hurrygames.grabber.vo.UserDataVO;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	import com.hurrygames.grabber.vo.home.HomeVO;
	import com.hurrygames.grabber.vo.map.UserMapProgressVO;
	import com.hurrygames.grabber.vo.skill.UserSkillsVO;
	import com.hurrygames.grabber.vo.storage.StorageInfo;
	
	/**
	 * Project : LandGrabbers
	 * UserProfile
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class UserProfile
	{
		private static  var _instance:UserProfile;
		
		public static function get instance():UserProfile
		{
			if(_instance)
			{
				return _instance;
			}else
			{
				_instance = new UserProfile();
			}
			return _instance;
		}
		
		public function UserProfile()
		{
			if(_instance)
			{
				throw(new Error("UserProfile 是单例模式,不能直接new"));
			}
		}
		
		[Bindable]
		/**
		 * 用户数据 
		 */		
		public var userData:UserDataVO = new UserDataVO();
		
		/**
		 * 用户过关相关数据. 
		 */		
		public var userProgress:UserMapProgressVO = new UserMapProgressVO();
		
		/**
		 * 用户技能相关数据 
		 */		
		public var userSkills:UserSkillsVO = new UserSkillsVO();;
		
		/**
		 * 用户家园的相关信息。 
		 */		
		public var userHome:HomeVO;
		
		/**
		 * 用户的装备信息 
		 */		
		public var userEquipments:Vector.<EquipmentVO>;
		
		/**
		 * 背包中的装备列表。 
		 */		
		public var userBags:StorageInfo;
		
	}
} 
