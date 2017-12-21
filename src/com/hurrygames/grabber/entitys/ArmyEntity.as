package com.hurrygames.grabber.entitys
{
	import com.hurrygames.grabber.core.BaseEntity;
	/**
	 * 表示一只军队。 
	 * @author Administrator
	 * 
	 */	
	public class ArmyEntity extends BaseEntity
	{
		/**
		 * 此军队的拥有者 
		 */		
		public var ownedPlayer:PlayerEntity;

		/**
		 * 从哪个城市出发的 
		 */		
		public var fromCity:CityEntity;
		
		/**
		 * 目标是哪个城市 
		 */		
		public var targetCity:CityEntity;
		
		public function ArmyEntity()
		{
			super();
		}
		
		override public function destory(deep:Boolean = true):void
		{
			super.destory(deep);
			ownedPlayer = null;
			fromCity = null;
			targetCity = null;
		}
	}
}