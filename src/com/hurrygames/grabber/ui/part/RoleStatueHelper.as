package com.hurrygames.grabber.ui.part
{
	import com.hurrygames.grabber.itemSys.EquipmentDes;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ItemDescriptionManager;
	import com.hurrygames.grabber.managers.ResourceLoadManager;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	import com.hurrygames.landgrabber.swc.HomeContent.RoleStatus;
	
	import flash.display.MovieClip;

	public class RoleStatueHelper
	{
		private var _role:RoleStatus;
		
		public function RoleStatueHelper(role:RoleStatus)
		{
			_role = role;
		}
		
		/**
		 * 装入一个装备 
		 * @param equipment
		 * 
		 */
		public function installEquipment(equipment:EquipmentVO):void
		{
			if(_role != null)
			{
				var des:EquipmentDes = ItemDescriptionManager.instance.equipmentDesDictionary[equipment.equipmentType] as EquipmentDes;
				var partMovie:MovieClip = _role["mc_part"+des.position] as MovieClip;
				while(partMovie.numChildren>0)
				{
					partMovie.removeChildAt(0);
				}
				var childPath:String = des.avatar_id.toString().charAt(1);
				var path:String = UrlConfig.RESOURCE_ROOT + ConfigManager.EQUIPMENT_ROOT +childPath+"/"+ des.avatar_id+".png";
				ResourceLoadManager.showRes(partMovie,path);
			}
		}
		
		/**
		 * 装入很多装备 
		 * @param equipments
		 * 
		 */
		public function installEquipments(equipments:Vector.<EquipmentVO>):void
		{
			if(equipments == null)
			{
				return;
			}
			removeAllEqiuipments();
			for each(var e:EquipmentVO in equipments)
			{
				installEquipment(e);
			}
		}
		
		/**
		 * 清除某个part。 
		 * @param equipment
		 * 
		 */		
		public function removeOneEquipment(equipment:EquipmentVO):void
		{
			var des:EquipmentDes = ItemDescriptionManager.instance.equipmentDesDictionary[equipment.equipmentType] as EquipmentDes;
			var partMovie:MovieClip = _role["mc_part"+des.position] as MovieClip;
			while(partMovie.numChildren>0)
			{
				partMovie.removeChildAt(0);
			}
		}
		
		/**
		 *清除所有的装备 
		 * 
		 */
		public function removeAllEqiuipments():void
		{
			for(var i:int = 1;i<9;i++)
			{
				var partMovie:MovieClip = _role["mc_part"+i] as MovieClip;
				while(partMovie.numChildren > 0)
				{
					partMovie.removeChildAt(0);
				}
			}
		}
	}
}