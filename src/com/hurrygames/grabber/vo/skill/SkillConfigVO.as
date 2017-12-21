package com.hurrygames.grabber.vo.skill
{
	
	/**
	 * Project : LandGrabbers
	 * SkillConfigVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class SkillConfigVO
	{
		/**
		 * id 
		 */		
		public var id:int;
		
		/**
		 * 技能等级 
		 */		
		public var level:int;
		
		/**
		 * 技能描述 
		 */		
		public var desc:String;
		
		/**
		 *技能名字 
		 */		
		public var name:String;
		
		/**
		 * 技能相关的城市类型 
		 */		
		public var cityType:int;
		
		/**
		 * 技能的值  
		 */		
		public var value:Number;
		
		/**
		 * 技能的种类 
		 */		
		public var skillType:int;
		
		public function SkillConfigVO()
		{
		}
	}
} 
