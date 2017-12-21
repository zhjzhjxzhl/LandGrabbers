package com.hurrygames.grabber.vo.storage
{
	import com.hurrygames.grabber.vo.BaseVO;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	
	public class StorageInfo extends BaseVO
	{
		/**
		 *用户id 
		 */
		public var uid:String;
		
		/**
		 *开启的格子数 
		 */
		public var cell_num:int;
		
//		/**
//		 *格子里的数据。
//		 */
//		public var cell_data:Vector.<StorageItem> = new Vector.<StorageItem>();
		
		/**
		 * 背包里的装备 
		 */
		public var equipments:Vector.<EquipmentVO> = new Vector.<EquipmentVO>();
		
		/**
		 * 背包里的道具 
		 */
		public var products:Vector.<ProductVO> = new Vector.<ProductVO>();
		
		public function StorageInfo(o:Object)
		{
			super(o);
		}
	}
}