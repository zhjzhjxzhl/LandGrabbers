package com.hurrygames.grabber.ui.cell
{
	import com.hurrygames.grabber.itemSys.EquipmentDes;
	import com.hurrygames.grabber.itemSys.ProductDesc;
	import com.hurrygames.grabber.managers.CenterEventDispatcher;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ItemDescriptionManager;
	import com.hurrygames.grabber.managers.ResourceLoadManager;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	import com.hurrygames.grabber.vo.storage.ProductVO;
	import com.hurrygames.grabber.vo.storage.StorageItem;
	
	import gs.easing.Strong;
	
	
	/**
	 * Project : LandGrabbers
	 * PackageItem
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class PackageItem extends BaseObject
	{
		public var item:*;
		
		public function PackageItem(item:*)
		{
			this.item = item;
			super();
		}
		
		override protected function destory():void
		{
			super.destory();
		}
		
		override protected function init():void
		{
			super.init();
			render();
		}
		
		private function render():void
		{
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			if(item is EquipmentVO)
			{
				//装备
				var edes:EquipmentDes = ItemDescriptionManager.instance.equipmentDesDictionary[item.equipmentType] as EquipmentDes;
				var childPath:String = edes.avatar_id.toString().charAt(1);
				var path:String = UrlConfig.RESOURCE_ROOT + ConfigManager.ICON_ROOT + childPath +"/icon_"+edes.avatar_id+".png";
				ResourceLoadManager.showRes(this,path,0,0,false);
			}else if(item is ProductVO)
			{
				//道具等
				var productDes:ProductDesc = ItemDescriptionManager.instance.productDescDictionary[item.product_typeId] as ProductDesc;
				var path1:String = UrlConfig.RESOURCE_ROOT + ConfigManager.ICON_ROOT + productDes.prodcut_icon+".png";
				ResourceLoadManager.showRes(this,path1,0,0,false);
			}
		}
		
		public function reInstallItem(item:*):void
		{
			this.item = item;
			render();
		}
	}
} 
