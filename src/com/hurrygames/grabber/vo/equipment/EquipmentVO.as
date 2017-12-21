package com.hurrygames.grabber.vo.equipment
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class EquipmentVO extends BaseVO
	{
		/**
		 * 装备id
		 */		
		public var equipmentId:int;
		/**
		 * 装备强化等级
		 */		
		public var equipmentStrengthenLevel:int;
		/**
		 * 装备类型，是哪种装备，对应装备配置表。
		 */		
		public var equipmentType:int;
		/**
		 *附加属性，目前最多三条。 
		 */		
		public var addPropertys:Vector.<AddPropertyVO>;
		
		/**
		 * 是否装备 
		 */
		public var isPutOn:Boolean = false;
		
		public function EquipmentVO(o:Object)
		{
			super(o);
		}
	}
}