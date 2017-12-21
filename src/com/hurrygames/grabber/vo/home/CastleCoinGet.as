package com.hurrygames.grabber.vo.home
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class CastleCoinGet extends BaseVO
	{
		
		/**
		 *获取的金币 
		 */
		public var getCoins:int;
		
		/**
		 * 城堡当前的能量 
		 */
		public var castleEnergy:int;
		
		/**
		 *城堡下次征收需要的能量 
		 */
		public var castleNeedEnergy:int;
		
		/**
		 *城堡下次征收可获得钱 
		 */
		public var castleGetCoin:int;
		
		public function CastleCoinGet(o:Object)
		{
			super(o);
		}
	}
}