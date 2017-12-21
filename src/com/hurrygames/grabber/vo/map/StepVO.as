package com.hurrygames.grabber.vo.map
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * StepVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class StepVO extends BaseVO
	{
		/**
		 * 大地图索引 
		 */		
		public var bigAreaIndex:int;
		
		/**
		 * 小区域索引 
		 */		
		public var smallAreaIndex:int;
		
		/**
		 *  此玩家过此关普通模式的时间。如果为0，则表示此用户还没有通过此模式
		 */		
		public var normalTime:Number;
		
		/**
		 *此玩家过此关高端模式的时间。如果为0，则表示此用户还没有通过此模式 
		 */		
		public var hardTime:Number;
		
		/**
		 *此玩家过此关传奇模式的时间。如果为0，则表示此用户还没有通过此模式 
		 */		
		public var veryHardTime:Number;
		
		/**
		 * 普通模式的星级。如果未过此模式，为-1
		 */		
		public var normalStarts:int;
		
		/**
		 *高端模式的星级。如果未过此模式，为-1 
		 */		
		public var hardStarts:int;
		
		/**
		 *传奇模式的星级。如果未过此模式，为-1 
		 */		
		public var veryHardStarts:int;
		
		public function StepVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
