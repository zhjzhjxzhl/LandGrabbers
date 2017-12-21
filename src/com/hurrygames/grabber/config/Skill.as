package com.hurrygames.grabber.config
{
	
	/**
	 * Project : LandGrabbers
	 * Skill
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Skill
	{
		/**
		 *技能id 
		 */		
		public var id:int;
		
		/**
		 *技能等级 
		 */		
		public var level:int;
		
		/**
		 *技能名字 
		 */		
		public var name:String;
		
		/**
		 * 技能描述 
		 */		
		public var des:String;
		
		/**
		 * 技能作用的城市类型 
		 */		
		public var cityType:int;
		
		/**
		 * 技能的数值 
		 */		
		public var value:Number;
		
		/**
		 * 技能的效果类型。
		 * 	1、部队攻击增益					>1
		 * 	2、部队移动速度增益				>1
		 * 	3、城市人口增长速度增益			>1
		 * 	4、城市防御力加成				>1
		 * 	5、城市升级消耗人口增益			<1
		 * 	6、城市升级时间减少				<1
		 * 	7、防御塔攻击加成				>1
		 * 	8、防御塔防御加成				>1
		 */		
		public var skillType:int;
		
		public function Skill()
		{
		}
	}
} 
