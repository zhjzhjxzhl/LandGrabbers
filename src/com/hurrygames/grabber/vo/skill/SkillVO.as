package com.hurrygames.grabber.vo.skill
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * SkillVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class SkillVO extends BaseVO
	{
		/**
		 * 技能id 
		 */		
		public var skillId:int;
		
		/**
		 * 技能级别 
		 */		
		public var skillLevel:int;
		
		public function SkillVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
