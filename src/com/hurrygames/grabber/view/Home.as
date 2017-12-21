package com.hurrygames.grabber.view
{
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.ui.controller.CastleServer;
	import com.hurrygames.grabber.ui.controller.UserInfoController;
	import com.hurrygames.grabber.ui.panel.UserBagPanelHelper;
	import com.hurrygames.grabber.ui.part.RoleStatueHelper;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.view.home.People;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	import com.hurrygames.grabber.vo.home.HomeVO;
	import com.hurrygames.grabber.vo.home.PeopleVO;
	import com.hurrygames.landgrabber.swc.HomeContent.CastleAllContent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import gs.TweenLite;
	
	/**
	 * Project : LandGrabbers
	 * Home
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Home extends Sprite
	{
		/**
		 *是否已经鞠躬过了。 
		 */
		private static var isInit:Boolean = false;
		
		protected var _castle:CastleAllContent;
		
		private var _peopleLayer:Sprite = new Sprite();
		
		/**
		 *所有人的列表 
		 */
		private var _peoples:Vector.<People> = new Vector.<People>();
		
		/**
		 * 用户雕像的帮助类。 
		 */
		public var roleHelper:RoleStatueHelper;
		
		public function Home()
		{
			_castle = new CastleAllContent();
			this.addChild(_castle);
			this.addChild(_peopleLayer);
			this.addChild(_castle.mc_frontLight);
			_castle.mc_frontLight.mouseChildren = _castle.mc_frontLight.mouseEnabled = false;
			roleHelper = new RoleStatueHelper(_castle.mc_role);
			roleHelper.removeAllEqiuipments();
		}
		
		public function init():void
		{
			if(UserProfile.instance.userHome == null)
			{
				UserInfoController.instance.getHomeInfo(installHomeData);
			}else
			{
				installHomeData();
			}
			initListeners();
			_castle.mc_castle.buttonMode = true;
			_castle.mc_role.buttonMode = true;
			
			if(UserProfile.instance.userEquipments != null)
			{
				installRoleData(UserProfile.instance.userEquipments);
			}else
			{
				UserInfoController.instance.getUserEquipment(function():void
				{
					installRoleData();
				});
			}
		}
		
		/**
		 * 装入城市中的玩家的雕像 
		 * @param equipments
		 * 
		 */
		public function installRoleData(equipments:Vector.<EquipmentVO> = null):void
		{
			if(equipments == null)
			{
				equipments = UserProfile.instance.userEquipments;
			}
			roleHelper.installEquipments(equipments);
		}
		
		/**
		 *初始化城堡里的内容 
		 * 
		 */
		private function installHomeData(home:HomeVO = null):void
		{
			if(home == null)
			{
				home = UserProfile.instance.userHome;
			}
			initCastale(home);
			initRoleData(home);
		}
		
		/**
		 * 将场景的建筑初始化。 
		 * @param home
		 * 
		 */
		protected function initCastale(home:HomeVO):void
		{
			_castle.mc_castle.gotoAndStop(home.castleLevel);
			_castle.mc_peopleHouse.gotoAndStop(home.castleLevel);
			_castle.mc_wall.gotoAndStop(home.castleLevel);
		}
		
		/**
		 *初始化角色的数据 
		 * 
		 */
		private function initRoleData(home:HomeVO):void
		{
			/*for each(var people:PeopleVO in home.peoples)
			{
				
			}*/
			for(var i:int = 0;i<3;i++)
			{
				var people:People = new People();
				people.y = 500;
				_peopleLayer.addChild(people);
				people.x = i*200+200;
				_peoples.push(people);
			}
			if(!isInit)
			{
				TweenLite.delayedCall(3,function():void
				{
					for each(var p:People in _peoples)
					{
						p.startJuGong();
					}
					isInit = true;
				});
			}
		}
		
		public function destory():void
		{
			destoryListeners();
		}
		
		private function initListeners():void
		{
			_castle.mc_castle.addEventListener(MouseEvent.MOUSE_OVER,showFilter);
			_castle.mc_castle.addEventListener(MouseEvent.MOUSE_OUT,hideFilter);
			_castle.mc_role.addEventListener(MouseEvent.MOUSE_OVER,showFilter);
			_castle.mc_role.addEventListener(MouseEvent.MOUSE_OUT,hideFilter);
			
			_castle.mc_castle.addEventListener(MouseEvent.CLICK,getCoin);
			_castle.mc_role.addEventListener(MouseEvent.CLICK,showPackage);
		}
		
		protected function showPackage(event:MouseEvent):void
		{
			POPUpManager.instance.showPop(new UserBagPanelHelper());
		}
		
		protected function getCoin(event:MouseEvent):void
		{
			CastleServer.instance.upgradeCastle(null);
		}
		
		protected function hideFilter(event:MouseEvent):void
		{
			var mc:MovieClip = event.currentTarget as MovieClip;
			if(mc != null)
			{
				mc.filters = [];
			}
		}
		
		protected function showFilter(event:MouseEvent):void
		{
			var mc:MovieClip = event.currentTarget as MovieClip;
			if(mc != null)
			{
				mc.filters = [new GlowFilter(0xffff00,1,8,8)];
			}
		}
		
		/**
		 * 
		 * 
		 */
		private function destoryListeners():void
		{
			_castle.mc_castle.removeEventListener(MouseEvent.MOUSE_OVER,showFilter);
			_castle.mc_castle.removeEventListener(MouseEvent.MOUSE_OUT,hideFilter);
			_castle.mc_role.removeEventListener(MouseEvent.MOUSE_OVER,showFilter);
			_castle.mc_role.removeEventListener(MouseEvent.MOUSE_OUT,hideFilter);
			
		}
	}
} 
