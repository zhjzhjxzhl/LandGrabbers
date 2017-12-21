package com.hurrygames.grabber.vo.home
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class CastleUpgradeVO extends BaseVO
	{
		/**
		 *当前等级 
		 */
		public var castleLevel:int;
		
		/**
		 *当前经验 
		 */
		public var castleBuildProgress:int;
		
		public function CastleUpgradeVO(o:Object)
		{
			super(o);
		}
	}
}