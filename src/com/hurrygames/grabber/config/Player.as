package com.hurrygames.grabber.config
{
	
	/**
	 * Project : LandGrabbers
	 * Player
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Player extends BaseModel
	{
		/**
		 * 人口增长速度 
		 */		
		public var population_growth:Number;
		
		/**
		 * 塔的攻击速度 
		 */		
		public var tower_speed:Number;
		
		/**
		 * 军队的移动速度 
		 */		
		public var army_speed:Number;
		
		/**
		 * 军队的攻击力 
		 */		
		public var army_attack:Number;
		
		/**
		 * 军队的防御力 
		 */		
		public var army_defence:Number;
		
		/**
		 * 塔的攻击范围. 
		 */		
		public var tower_range:Number;
		
		/**
		 * ai攻击延迟，即没多久会发起一次攻击
		 */		
		public var ai_attack_delay:int;
		
		/**
		 * ai每次攻击能发起的最大军队数 
		 */		
		public var ai_max_armies_per_attack:int;
		
		/**
		 * ai升级的起点。人口达到这个比例会升级
		 */		
		public var ai_upgrade_treshold:Number;
		
		/**
		 * ai必须发动攻击的人口比例 
		 */		
		public var ai_panic_attack_treshold:Number;
		
		/**
		 *玩家的种族，0表示人族，1表示精灵。。。等等 
		 */
		public var zhongzhu:int = 0;
		
		/**
		 *ai发起攻击的比例 
		 */
		public var ai_attack_upgread:Number = 0;
		
		/**
		 *ai攻击的时候，目标建筑优先级比重。 
		 */
		public var ai_build_select_prcent:Number = 0;
		
		/**
		 *ai优先攻击的建筑的选择顺序，0是塔楼，1是马厩，二是城堡，3是普通城市 
		 */
		public var ai_build_selecte:Array = [];
		
		/**
		 *ai攻击目标选择时，距离所占比重
		 */
		public var ai_build_distance_prcent:Number = 0;
		
		/**
		 *ai攻击目标选择时，人口因素所占的比例 
		 */
		public var ai_build_people_prcent:Number = 0;
		
		/**
		 * ai攻击的时候，建筑所属玩家所占的比例。 
		 */
		public var ai_build_player_prcent:Number = 0;
		
		/**
		 *ai攻击的时候，建筑所属玩家的优先选择顺序。0为中立玩家，1为玩家本身，2为其他势力. 
		 */
		public var ai_build_owner_select:Array = [];
		
		public function Player(string:String)
		{
			super(string);
		}
	}
} 
