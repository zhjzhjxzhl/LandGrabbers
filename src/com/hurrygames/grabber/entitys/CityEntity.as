package com.hurrygames.grabber.entitys
{
	import com.hurrygames.grabber.core.BaseEntity;
	
	
	/**
	 * Project : LandGrabbers
	 * CityEntity
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class CityEntity extends BaseEntity
	{
		public var OwnerPlayEntity:PlayerEntity;
		
		public function CityEntity()
		{
			super();
		}
		
		override public function destory(deep:Boolean = true):void
		{
			super.destory(deep);
			OwnerPlayEntity = null;
		}
		
	}
} 
