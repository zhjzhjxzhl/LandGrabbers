package com.hurrygames.grabber.managers
{
	
	/**
	 * Project : LandGrabbers
	 * UrlConfig
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class UrlConfig
	{
		/**
		 * gateWay 
		 */		
		public static var GATE_WAY:String = "";
		
		/**
		 * 资源的目录。cdn的时候，需要有。 
		 */		
		public static var RESOURCE_ROOT:String = "";
		
		/**
		 * 接口编号：1
		 * 获取用户基础信息 
		 */		
		public static const GET_USER_INFO:String = "?act=user.getUserInfo";
		
//		public static const GET_USER_INFO:String = "UserInfo.json";
		/**
		 * 接口编号：2
		 *获取地图信息 
		 */		
		public static const GET_MAP_INFO:String = "?act=map.getMapInfo";
//		public static const GET_MAP_INFO:String = "MapInfo.json";
		/**
		 * 接口编号：3
		 * 获取擂主信息 
		 */		
		public static const GET_MASTER_INFO:String = "?act=map.getMasterInfo";
		
		/**
		 * 接口编号：4
		 * 获取好友列表 
		 */		
		public static const GET_FRIEND_LIST:String = "?act=friend.getFriendList";
		/**
		 * 接口编号：5
		 * 获取用户的技能 
		 */		
		public static const GET_SKILL_INFO:String = "?act=skill.getSkillInfo";
//		public static const GET_SKILL_INFO:String = "Skills.json";
		
		/**
		 * 接口编号：6
		 * 获取用户的成就 
		 */		
		public static const GET_ACHIEVEMENT_INFO:String = "?act=achievement.getAchievementInfo";
		
		/**
		 * 接口编号：7
		 * 开始某一关 
		 */		
		public static const START_ONE_LEVEL:String = "?act=chanllenge.start";
		
		/**
		 *接口编号：8
		 * 通过某一关 
		 */		
		public static const PASS_ONE_LEVEL:String = "?act=chanllenge.end";
		
		/**
		 * 接口编号：9
		 * 使用一个魔法。 
		 */		
		public static const USE_ONE_MAGIC:String = "";
		
		/**
		 * 接口编号：10
		 * 获取玩家的家园信息 
		 */		
		public static const GET_USER_HOMEINFO:String = "?act=castle.getCastleInfo";
		
		/**
		 *接口编号：11
		 * 获取玩家的装备信息 
		 */		
		public static const GET_USER_EQUIPMENT:String = "?act=equipment.getEquipmentInfo";
		
		/**
		 *接口编号：12(已废）
		 * 获取玩家的背包装备信息。 
		 */		
		public static const GET_USER_BAG:String = "?act=equipment.getEquipmentBagInfo";
		
		/**
		 *借口编号：13
		 * 强化一件装备 
		 */		
		public static const STRENGTHEN_ONE_EQUIPMENT:String = "";
		
		/**
		 * 接口编号：14
		 * 城堡征收 
		 */		
		public static const CASTLE_COLLECT:String = "?act=castle.getCoin";
		
		/**
		 *接口编号：15
		 * 给好友城堡充能。 
		 */		
		public static const ENERGY_FRIEND_CASTLE:String = "?act=friend.addFirendCastleEnergy";
		
		/**
		 * 接口编号：16
		 * 获取用户背包里的装饰列表 
		 */		
		public static const GET_USER_DECORATION:String = "?act=bag.getDecorationsBagInfo";
		
		/**
		 *接口编号：17
		 * 用户安装或者卸下一个装饰。 
		 */		
		public static const USE_OR_UNUSE_ONE_DECORATION:String = "";
		
		/**
		 * 接口编号：18
		 * 用户装备或者卸下一个装备。 
		 */		
		public static const USE_OR_UNUSE_ONE_EQUIPMENT:String = "";
		
		/**
		 * 接口编号：19
		 *给自己的城堡充能 
		 */		
		public static const FILL_ENERGY_TO_SELF_CASTLE:String = "?act=castle.addEnergy";
		
		/**
		 * 接口编号：20
		 *点击居民抖钱 
		 */
		public static const SHAKE_COINS:String = "?act=castle.shakeCoin";
		
		/**
		 * 接口编号：21
		 *城堡升级 
		 */
		public static const UPGRADE_CASTLE:String = "?act=castle.upgradeCastle";
		
		/**
		 *接口编号：22
		 * 获取消息列表 
		 */
		public static const GET_ALL_MESSAGE:String = "?act=message.getAllMessage";
		
		/**
		 * 23
		 *获取背包信息 
		 */
		public static const GET_STORAGE:String = "?act=storage.getStorages";
		
		/**
		 * 24
		 *开个背包格子 
		 */
		public static const OPEN_PACKAGE_CELL:String = "?act=storage.openCell";
		
		/**
		 * 28
		 *装上一个装备 
		 */
		public static const DRESS_ONE_EQUIPMENT:String = "?act=equipment.dressEquipment";
		
		/**
		 * 29
		 *卸下一个装备 
		 */
		public static const UNDRESS_ONE_EQUIPMENT:String = "?act=equipment.undressEquipment";
		
		/**
		 *30
		 * 访问好友加 
		 */
		public static const GET_FRIEND_INFO:String = "?act=friend.getFriendInfo";
		
		public function UrlConfig()
		{
		}
		
	}
} 
