package com.hurrygames.grabber.ui.controller
{
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.ServerCall;
	import com.hurrygames.grabber.vo.UserDataVO;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	import com.hurrygames.grabber.vo.home.HomeVO;
	import com.hurrygames.grabber.vo.map.OneLevelMasterInfo;
	import com.hurrygames.grabber.vo.map.UserMapProgressVO;
	import com.hurrygames.grabber.vo.skill.UserSkillsVO;
	import com.hurrygames.grabber.vo.storage.StorageInfo;
	import com.hurrygames.grabber.vo.storage.StorageItem;
	
	import flash.net.URLVariables;
	
	/**
	 * Project : LandGrabbers
	 * UserInfoController
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class UserInfoController
	{
		private static var _instance:UserInfoController;
		public static function get instance():UserInfoController
		{
			if(_instance == null)
			{
				_instance = new UserInfoController();
			}
			return _instance;
		}
		public function UserInfoController()
		{
			if(_instance != null)
			{
				throw new Error("UserInfoController是单例类");
			}
		}
		
		/**
		 * 获取用户的基本信息，用户名，头像等。 
		 * @param callBack
		 * 
		 */		
		public function GetUserInfo(callBack:Function = null):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_USER_INFO,function(result:Object):void
			{
				if(result.code == 1)
				{
					var ud:UserDataVO = new UserDataVO(result.data);
					UserProfile.instance.userData = ud;
					if(callBack != null)
					{
						callBack();
					}
				}else
				{
					trace("获取用户信息失败");
				}
			});
		}
		
		/**
		 * 获取用户地图相关的信息。 
		 * @param callBack
		 * 
		 */		
		public function getMapInfo(callBack:Function = null):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_MAP_INFO,function(result:Object):void
			{
				if(result.code == 1)
				{
					UserProfile.instance.userProgress = new UserMapProgressVO(result.data);
					///此处打开所有关卡
					UserProfile.instance.userProgress.bigAreaIndex = 0;
					UserProfile.instance.userProgress.smallAreaIndex = 8;
					if(callBack != null)
					{
						callBack();
					}
				}
			});
		}
		
		/**
		 * 获取某一关擂主信息 
		 * @param callBack 接受一个OneLevelMasterInfo的vo作为参数。
		 * 传大地图和小地图的索引。
		 * 
		 */
		public function getMasterInfo(bai:int,sai:int,callBack:Function):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_MASTER_INFO,function(result:Object):void
			{
				if(result.code == 1)
				{
					var masters:OneLevelMasterInfo = new OneLevelMasterInfo(result.data);
					if(callBack != null)
					{
						callBack(masters);
					}
				}
			});
		}
		
		/**
		 * 获取用户技能相关的信息。 
		 * @param callBack
		 * 
		 */		
		public function getSkillInfo(callBack:Function = null):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_SKILL_INFO,function(result:Object):void
			{
				if(result.code == 1)
				{
					UserProfile.instance.userSkills = new UserSkillsVO(result.data);
					if(callBack != null)
					{
						callBack();
					}
				}
			});
		}
		
		/**
		 * 获取用户的家园信息 
		 * @param callBack
		 * 
		 */		
		public function getHomeInfo(callBack:Function = null):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_USER_HOMEINFO,function(result:Object):void
			{
				if(result.code == 1)
				{
					UserProfile.instance.userHome = new HomeVO(result.data);
					if(callBack != null)
					{
						callBack();
					}
				}
			});
		}
		
		/**
		 * 获取用户的装备 
		 * @param callBack
		 * 
		 */		
		public function getUserEquipment(callBack:Function = null):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_USER_EQUIPMENT,function(result:Object):void
			{
				if(result.code == 1)
				{
					var equipments:Vector.<EquipmentVO> = new Vector.<EquipmentVO>();
					for each(var o:Object in result.data.equipments)
					{
						equipments.push(new EquipmentVO(o));
					}
					UserProfile.instance.userEquipments = equipments;
					if(callBack != null)
					{
						callBack();
					}
				}
			});
		}
		
		/**
		 * 获取用户背包 
		 * @param callBack
		 * 
		 */		
		public function getUserBag(callBack:Function = null):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.GET_STORAGE,function(result:Object):void
			{
				if(result.code == 1)
				{
					var bags:StorageInfo = new StorageInfo(result.data);
					UserProfile.instance.userBags = bags;
					if(callBack != null)
					{
						callBack();
					}
				}
			});
		}
		
		/**
		 * 装上一件装备 
		 * @param storageItem
		 * 
		 */
		public function loadOneEquipment(equipment:EquipmentVO,callBack:Function = null):void
		{
			var variable:URLVariables = new URLVariables();
			variable.equipmentId = equipment.equipmentId;
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.DRESS_ONE_EQUIPMENT,function(result:Object):void
			{
				if(result.code == 1)
				{
					if(callBack != null)
					{
						callBack();
					}
				}
			},variable);
		}
		
		/**
		 * 卸下一件装备 
		 * @param equipment
		 * 
		 */
		public function unloadOneEquipment(equipment:EquipmentVO,callBack:Function = null):void
		{
			var variable:URLVariables = new URLVariables();
			variable.equipmentId = equipment.equipmentId;
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.UNDRESS_ONE_EQUIPMENT,function(result:Object):void
			{
				if(result.code == 1)
				{
					if(callBack != null)
					{
						callBack();
					}
				}
			},variable);
		}
	}
} 
