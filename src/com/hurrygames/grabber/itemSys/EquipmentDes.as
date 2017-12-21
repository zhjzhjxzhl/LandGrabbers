package com.hurrygames.grabber.itemSys
{
	/**
	 * Project : LandGrabbers
	 * EquipmentDes
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class EquipmentDes extends ItemDesBase
	{
		
		public var equipment_id:int;
		/**
		 *名字 
		 */
		public var name:String;
		
		/**
		 *质量 
		 */
		public var quality:int;
		
		/**
		 *位置 
		 */
		public var position:int;
		
		/**
		 *功能类型 
		 */
		public var property_type:*;
		
		/**
		 *功能值 
		 */
		public var property_value:Number;
		
		/**
		 *随机部分 
		 */
		public var random_property:Number;
		
		/**
		 *价格 
		 */
		public var price:int;
		
		/**
		 *描述 
		 */
		public var description:String;
		
		public var suit_id:int;
		
		public var avatar_id:int;
		
		public var score:Number;
		
		public function EquipmentDes(object:Object=null)
		{
			super(object);
		}
	}
} 
