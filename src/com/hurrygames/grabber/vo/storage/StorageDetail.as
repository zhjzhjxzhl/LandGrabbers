package com.hurrygames.grabber.vo.storage
{
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	
	
	/**
	 * Project : LandGrabbers
	 * StorageDetail
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class StorageDetail extends EquipmentVO
	{
		/**
		 *產品id 
		 */
		public var product_id:int;
		
		/**
		 *产品个数 
		 */
		public var product_num:int;
		
		public function StorageDetail(o:Object = null)
		{
			super(o);
		}
		
		public function initDataFromEquipment(equipment:EquipmentVO):void
		{
			this.equipmentId = equipment.equipmentId;
			this.equipmentStrengthenLevel = equipment.equipmentStrengthenLevel;
			this.equipmentType = equipment.equipmentType;
			this.addPropertys = equipment.addPropertys;
		}
	}
} 
