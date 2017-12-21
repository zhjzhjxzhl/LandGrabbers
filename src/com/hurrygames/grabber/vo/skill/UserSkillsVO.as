package com.hurrygames.grabber.vo.skill
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * UserSkillsVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class UserSkillsVO extends BaseVO
	{
		/**
		 * 可用技能点数 
		 */		
		public var useableFriendPoints:int;
		
		/**
		 * 总共的点数 
		 */		
		public var totalFriendPoints:int;
		
		/**
		 * 用户技能列表 
		 */		
		public var Skills:Vector.<SkillVO> = new Vector.<SkillVO>();
		
		public function UserSkillsVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
