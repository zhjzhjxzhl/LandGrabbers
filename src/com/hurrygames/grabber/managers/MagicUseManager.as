package com.hurrygames.grabber.managers
{
	
	/**
	 * Project : LandGrabbers
	 * SkillUseManager
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class MagicUseManager
	{
		public function MagicUseManager()
		{
		}
		
		/**
		 * 根据参数和id使用技能。 
		 * @param skillId
		 * @param paras
		 * 
		 */		
		public static function userMagic(magicId:int,paras:Object):void
		{
			//1-20分别是20个不同的魔法
			switch(magicId)
			{
				case 1:
					//休战
					break;
				case 2:
					//减速
					break;
				case 3:
					break;
				default:
					throw(new Error("暂时没有此id的魔法："+magicId));
					break;
			}
		}
	}
} 
