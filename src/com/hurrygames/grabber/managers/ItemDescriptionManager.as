package com.hurrygames.grabber.managers
{
	import com.hurrygames.grabber.itemSys.EquipmentDes;
	import com.hurrygames.grabber.itemSys.ProductDesc;
	
	import flash.utils.Dictionary;

	/**
	 * Project : LandGrabbers
	 * ItemDescriptionManager
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ItemDescriptionManager
	{
		/**
		 *装备描述的字典。键是id，值是内容 
		 */
		public var equipmentDesDictionary:Dictionary = new Dictionary();
		
		/**
		 *所有非装备类物品的字典，键是id，值是内容。 
		 */
		public var productDescDictionary:Dictionary = new Dictionary();
		
		private static var _instance:ItemDescriptionManager;
		public static function get instance():ItemDescriptionManager
		{
			if(_instance == null)
			{
				_instance = new ItemDescriptionManager();
			}
			return _instance;
		}
		public function ItemDescriptionManager()
		{
		}
		
		public function installEquipment(equipments:XML):void
		{
			for each(var xml:XML in equipments.database.table)
			{
				var equi:EquipmentDes = new EquipmentDes();
				equi.installFromXml(xml);
				equipmentDesDictionary[equi.equipment_id] = equi;
			}
		}
		
		public function installProduct(product:XML):void
		{
			for each(var xml:XML in product.database.table)
			{
				var productDes:ProductDesc = new ProductDesc();
				productDes.installFromXml(xml);
				productDescDictionary[productDes.product_id] = productDes;
			}
		}
	}
} 
