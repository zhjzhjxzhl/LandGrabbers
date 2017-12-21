package com.hurrygames.grabber.vo.map
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	/**
	 * Project : LandGrabbers
	 * UserMapProgressVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class UserMapProgressVO extends BaseVO
	{
		/**
		 *  已经玩到第几章大地图 目前只有0----4，共5节
		 */		
		public var bigAreaIndex:int = 4;
		
		/**
		 * 当前已经玩到小地图的第几关0----8,共9节
		 */		
		public var smallAreaIndex:int = 8;
		
		/**
		 * 用户已经通过的关 
		 */		
		public var steps:Vector.<StepVO>;
		
		public function UserMapProgressVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
