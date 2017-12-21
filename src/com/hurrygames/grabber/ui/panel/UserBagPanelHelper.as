package com.hurrygames.grabber.ui.panel
{
	import com.hurrygames.grabber.itemSys.EquipmentDes;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ItemDescriptionManager;
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.managers.ResourceLoadManager;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.ui.MainMenuBar;
	import com.hurrygames.grabber.ui.MainUIController;
	import com.hurrygames.grabber.ui.cell.PackageItem;
	import com.hurrygames.grabber.ui.controller.UserInfoController;
	import com.hurrygames.grabber.ui.part.RoleStatueHelper;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	import com.hurrygames.grabber.vo.storage.StorageDetail;
	import com.hurrygames.grabber.vo.storage.StorageInfo;
	import com.hurrygames.grabber.vo.storage.StorageItem;
	import com.hurrygames.landgrabber.swc.EquipmentAndBag.EquipmentMC;
	import com.hurrygames.landgrabber.swc.HomeContent.RoleStatus;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * Project : LandGrabbers
	 * UserBagPanel
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class UserBagPanelHelper extends BaseObject
	{
		private var _equip:EquipmentMC;
		
		/**
		 *人物塑像 
		 */
		private var _role:RoleStatus;
		
		private var _roleHelper:RoleStatueHelper;
			
		public function UserBagPanelHelper()
		{
			super();
		}
		
		override protected function destory():void
		{
			super.destory();
			cleanItems();
			destoryListeners();
		}
		
		override protected function init():void
		{
			super.init();
			_equip = new EquipmentMC();
			_equip.x = ConfigManager.GAME_WIDTH/2;
			_equip.y = ConfigManager.GAME_HEIGHT/2;
			
			this.addChild(_equip);
			
			_role = new RoleStatus();
			_role.x = -225;
			_role.y = -110;
			_equip.addChild(_role);
			
			_roleHelper = new RoleStatueHelper(_role);
			_roleHelper.removeAllEqiuipments();
			
			initListeners();
			
			_equip.mc_beibao.gotoAndStop(1);
			_equip.mc_lingzhu.gotoAndStop(1);
			_equip.mc_xiangxi.gotoAndStop(2);
			
			if(UserProfile.instance.userBags != null)
			{
				installData(UserProfile.instance.userBags);
			}else
			{
				UserInfoController.instance.getUserBag(installBag);
			}
			
			if(UserProfile.instance.userEquipments != null)
			{
				installEquipment(UserProfile.instance.userEquipments);
			}else
			{
				UserInfoController.instance.getUserEquipment(function():void
				{
					installEquipment(UserProfile.instance.userEquipments);
				});
			}
		}
		
		/**
		 * 将装备装入到雕像和面板。 
		 * @param equips
		 * 
		 */
		public function installEquipment(equips:Vector.<EquipmentVO>):void
		{
			_roleHelper.installEquipments(equips);
			setPanelEquipments(equips);
		}
		
		/**
		 * 在面板上装入一个装备 ,返回的位换下来的装备。如果原始位置没有装备，则返回null.
		 * @param equip
		 * 
		 */
		private function setPanelEquipment(equipment:EquipmentVO):EquipmentVO
		{
			var des:EquipmentDes = ItemDescriptionManager.instance.equipmentDesDictionary[equipment.equipmentType] as EquipmentDes;
			var partMovie:MovieClip = _equip["mc_part"+des.position] as MovieClip;
			while(partMovie.numChildren>0)
			{
				partMovie.removeChildAt(0);
			}
			var old:EquipmentVO = null;
			if(partMovie.hasOwnProperty("equipment") && (partMovie.equipment is EquipmentVO))
			{
				old = partMovie.equipment;
			}
			partMovie.equipment = equipment;
			var childPath:String = des.avatar_id.toString().charAt(1);
			var path:String = UrlConfig.RESOURCE_ROOT + ConfigManager.ICON_ROOT +childPath+"/icon_"+ des.avatar_id+".png";
			ResourceLoadManager.showRes(partMovie,path);
			
			partMovie.doubleClickEnabled = true;
			partMovie.removeEventListener(MouseEvent.DOUBLE_CLICK,undressEquipment);
			partMovie.addEventListener(MouseEvent.DOUBLE_CLICK,undressEquipment);
			
			return old;
		}
		
		protected function undressEquipment(event:MouseEvent):void
		{
			var part:MovieClip = event.currentTarget as MovieClip;
			if(part.hasOwnProperty("equipment") && part.equipment is EquipmentVO)
			{
				var equipment:EquipmentVO = part.equipment as EquipmentVO;
				UserInfoController.instance.unloadOneEquipment(equipment,function():void
				{
					delete part.equipment;
					while(part.numChildren>0)
					{
						part.removeChildAt(0);
					}
					_roleHelper.removeOneEquipment(equipment);
					
					var index:int = UserProfile.instance.userEquipments.indexOf(equipment);
					if(index != -1)
					{
						UserProfile.instance.userEquipments.splice(index,1);
					}
					
					UserProfile.instance.userBags.equipments.push(equipment);
					installBag();
				});
			}
		}
		
		private function setPanelEquipments(equipments:Vector.<EquipmentVO>):void
		{
			for each(var e:EquipmentVO in equipments)
			{
				setPanelEquipment(e);
			}
		}
		
		private function installBag():void
		{
			installData(UserProfile.instance.userBags);
		}
		
		public function installData(storage:StorageInfo):void
		{
			clearBag();
			//将装备全部显示。做成装备和道具两个切页。
			for(var i:int = 0;i<storage.equipments.length;i++)
			{
				var pi:PackageItem = new PackageItem(storage.equipments[i]);
				pi.x = 42 + (i%4)*68;
				pi.y = -158 + (Math.floor(i/4))*68;
				pi.name = "packageItem";
				_equip.addChild(pi);
				pi.doubleClickEnabled = true;
				pi.addEventListener(MouseEvent.DOUBLE_CLICK,useOneEquipment);
			}
		}
		
		private function clearBag():void
		{
			while(_equip.getChildByName("packageItem") != null)
			{
				_equip.removeChild(_equip.getChildByName("packageItem"));
			}
		}
		
		/**
		 * 使用一个装备 
		 * @param event
		 * 
		 */
		protected function useOneEquipment(event:MouseEvent):void
		{
			var pi:PackageItem = event.currentTarget as PackageItem;
			var equipment:EquipmentVO = pi.item as EquipmentVO;
			if(equipment != null)
			{
				//装备
				var old:EquipmentVO = setPanelEquipment(equipment);
				if(old != null)
				{
					UserInfoController.instance.unloadOneEquipment(old,function():void
					{
						UserInfoController.instance.loadOneEquipment(equipment,function():void
						{
							//将本地数据更换。
							var index:int = UserProfile.instance.userEquipments.indexOf(old);
							if(index != -1)
							{
								UserProfile.instance.userEquipments.splice(index,1);
							}
							UserProfile.instance.userEquipments.push(equipment);
							
							index = UserProfile.instance.userBags.equipments.indexOf(equipment);
							if(index != -1)
							{
								UserProfile.instance.userBags.equipments.splice(index,1);
								if(old != null)
								{
									UserProfile.instance.userBags.equipments.splice(index,0,old);
								}
							}
							
							_roleHelper.installEquipment(equipment);
							if(old != null)
							{
								pi.reInstallItem(old);
							}else
							{
								installBag();
							}
						});
					});
				}else
				{
					UserInfoController.instance.loadOneEquipment(equipment,function():void
					{
						//将本地数据更换。
						var index:int = UserProfile.instance.userEquipments.indexOf(old);
						if(index != -1)
						{
							UserProfile.instance.userEquipments.splice(index,1);
						}
						UserProfile.instance.userEquipments.push(equipment);
						
						index = UserProfile.instance.userBags.equipments.indexOf(equipment);
						if(index != -1)
						{
							UserProfile.instance.userBags.equipments.splice(index,1);
							if(old != null)
							{
								UserProfile.instance.userBags.equipments.splice(index,0,old);
							}
						}
						
						_roleHelper.installEquipment(equipment);
						if(old != null)
						{
							pi.reInstallItem(old);
						}else
						{
							installBag();
						}
					});
				}
			}
		}
		
		public function cleanItems():void
		{
			while(_equip.getChildByName("packageItem"))
			{
				_equip.removeChild(_equip.getChildByName("packageItem"));
			}
		}
		
		private function initListeners():void
		{
			_equip.btn_close.addEventListener(MouseEvent.CLICK,close);
		}
		
		protected function close(event:MouseEvent):void
		{
			POPUpManager.instance.removePop(this);
			if(MainUIController.instance.homeContent != null)
			{
				MainUIController.instance.homeContent.installRoleData();
			}
		}
		
		private function destoryListeners():void
		{
			_equip.btn_close.removeEventListener(MouseEvent.CLICK,close);
		}
		
	}
} 
