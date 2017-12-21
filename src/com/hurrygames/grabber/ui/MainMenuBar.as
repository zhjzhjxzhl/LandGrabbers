package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.ui.panel.UserBagPanelHelper;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.landgrabber.swc.HomeUI.HomeMenuBar;
	
	import flash.events.MouseEvent;
	
	
	/**
	 * Project : LandGrabbers
	 * MainMenuBar 家园下面的主ui
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class MainMenuBar extends BaseObject
	{
		private var _mainBar:HomeMenuBar;
		
		public function MainMenuBar()
		{
			super();
			_mainBar = new HomeMenuBar();
			_mainBar.x = 667.55;
			_mainBar.y = 538.15;
			this.addChild(_mainBar);
		}
		
		override protected function destory():void
		{
			super.destory();
			_mainBar.btn_achievement.removeEventListener(MouseEvent.CLICK,showAchievement);
			_mainBar.btn_build.removeEventListener(MouseEvent.CLICK,showBuild);
			_mainBar.btn_role.removeEventListener(MouseEvent.CLICK,showRole);
			_mainBar.btn_shop.removeEventListener(MouseEvent.CLICK,showShop);
			_mainBar.btn_technology.removeEventListener(MouseEvent.CLICK,showTechnology);
			_mainBar.btn_startFight.removeEventListener(MouseEvent.CLICK,startFight);
		}
		
		override protected function init():void
		{
			super.init();
			_mainBar.btn_achievement.addEventListener(MouseEvent.CLICK,showAchievement);
			_mainBar.btn_build.addEventListener(MouseEvent.CLICK,showBuild);
			_mainBar.btn_role.addEventListener(MouseEvent.CLICK,showRole);
			_mainBar.btn_shop.addEventListener(MouseEvent.CLICK,showShop);
			_mainBar.btn_technology.addEventListener(MouseEvent.CLICK,showTechnology);
			_mainBar.btn_startFight.addEventListener(MouseEvent.CLICK,startFight);
		}
		
		protected function startFight(event:MouseEvent):void
		{
			MainUIController.instance.setMode(MainUIController.SELECTOR_UI);
		}
		
		protected function showTechnology(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function showShop(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function showRole(event:MouseEvent):void
		{
			POPUpManager.instance.showPop(new UserBagPanelHelper());
			
		}
		
		protected function showBuild(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function showAchievement(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
	}
} 
