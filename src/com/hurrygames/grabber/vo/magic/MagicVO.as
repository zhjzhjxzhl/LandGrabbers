package com.hurrygames.grabber.vo.magic
{
	
	/**
	 * Project : LandGrabbers
	 * MagicVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class MagicVO
	{
		/**
		 * id 
		 */		
		public var id:int;
		
		/**
		 *魔法名字 
		 */		
		public var name:String;
		
		/**
		 * 魔法开放等级 
		 */		
		public var openLevel:int;
		
		/**
		 *魔法描述 
		 */		
		public var desc:String;
		
		/**
		 *魔法使用需要的钻石数 
		 */		
		public var needDiamond:int;
		
		/**
		 *魔法cd 
		 */		
		public var cd:int;
		
		/**
		 * 如果是持续性技能，则提供此技能持续的时间数。 
		 */		
		public var lastTime:int;
		
		public function MagicVO()
		{
		}
	}
} 
