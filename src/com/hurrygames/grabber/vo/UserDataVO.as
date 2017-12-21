package com.hurrygames.grabber.vo
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * UserDataVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	[Bindable]
	public class UserDataVO extends BaseVO
	{
		/**
		 * 用户名 
		 */		
		public var name:String = "aa";
		
		/**
		 * 用户头像 
		 */		
		public var imgurl:String;
		
		/**
		 * 用户id 
		 */		
		public var uid:int;
		
		/**
		 * 用户级别 
		 */		
		public var level:int;
		
		/**
		 * 用户经验 
		 */		
		public var exp:int;
		
		/**
		 * 用户游戏币 
		 */		
		public var gold:int;
		
		/**
		 *用户的充值币 
		 */		
		public var diamond:int;
		
		/**
		 * 用户的行动力
		 */		
		public var energy:int;
		
		/**
		 * 用户离获取下一个行动力的时间。时间戳。秒数 
		 */		
		public var nextEnergyTime:int;
		
		public function UserDataVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
