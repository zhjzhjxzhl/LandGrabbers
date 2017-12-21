package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.ui.part.MessageAndActive;
	import com.hurrygames.grabber.ui.part.SettingHelper;
	import com.hurrygames.grabber.ui.part.TopInfoHelper;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.utils.EffectUtil;
	import com.hurrygames.grabber.view.FriendHome;
	import com.hurrygames.grabber.view.Home;
	import com.hurrygames.grabber.vo.friend.FriendDetailInfo;
	import com.hurrygames.landgrabber.swc.HomeUI.GoHomeButton;
	import com.hurrygames.swc.MainUI.UIAllMainUI;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import flashx.textLayout.elements.Configuration;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	/**
	 * Project : LandGrabbers
	 * MainUIHelper
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class MainUIController extends BaseObject
	{
		public static const SELECTOR_UI:String = "selectorUI";
		
		public static const FIGHT_UI:String = "fightUI";
		
		public static const HOME_UI:String = "homeUI";
		
		public static const FRIEND_HOME:String = "friendHome";
	
		/**
		 *关卡选择ui 
		 */
		public var selecteUi:SelecteUIHelper;
		/**
		 * 返回按钮 
		 */		
		public var backSprite:Sprite;
		
		/**
		 * 战斗ui 
		 */		
		public var fightUiHelper:FightUIHelper;
		
		/**
		 *设置ui 
		 */
		public var settingUIHelper:SettingHelper;
		
		/**
		 *顶部ui 
		 */
		public var topUIHelper:TopInfoHelper;
		
		/**
		 *好友列表 
		 */
		public var friendList:FriendsListHelper;
		
		/**
		 *菜单栏 
		 */
		public var menuBar:MainMenuBar;
		
		/**
		 *任务列表 
		 */
		public var taskList:TaskListHelper;
		
		/**
		 *消息和活动 
		 */
		public var messageActive:MessageAndActive;
		
		/**
		 *城堡的内容部分 
		 */
		public var homeContent:Home;
		
		/**
		 *当前ui的类型 
		 */
		private var _currentUIType:String;
		
		/**
		 * 好友家 
		 */
		public var friendHome:FriendHome;
		
		private static var _instance:MainUIController;
		public static function get instance():MainUIController
		{
			if(_instance == null)
			{
				_instance = new MainUIController();
			}
			return _instance;
		}
		
		public function MainUIController()
		{
			backSprite = new Sprite();
			backSprite.graphics.beginFill(0xffff00);
			backSprite.graphics.drawCircle(0,0,30);
			backSprite.graphics.endFill();
			backSprite.x = 600;
			backSprite.y = 30;
		}
		
		override protected function init():void
		{
			//默认是选择
			setMode(HOME_UI);
			backSprite.addEventListener(MouseEvent.CLICK,backToSelector);
		}
		
		
		
		
		public function backToSelector(e:MouseEvent):void
		{
			LandGrabbers.instance.warField.destory();
			LandGrabbers.instance.contentLayer.removeChild(LandGrabbers.instance.warField);
			setMode(SELECTOR_UI);
			trace(System.totalMemory);
			if(System.totalMemory > 50<<20)
			{
				ConfigManager.instance.clearAnimation();
				trace("内存大于100M，试图清理");
			}
		}
		
		override protected function destory():void
		{
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
		}
		
		/**
		 * 设置主UI的样式。目前有关卡选择和战斗ui。 
		 * @param type
		 * 
		 */		
		public function setMode(type:String,...rest):void
		{
			if(_currentUIType == type)
			{
				return;
			}
			_currentUIType = type;
			//移除所有的对象。
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			
			switch(type)
			{
				case SELECTOR_UI:
					//关卡选择界面
					selecteUi = new SelecteUIHelper();
					this.addChild(selecteUi);
					break;
				case FIGHT_UI:
					//战斗界面
					this.addChild(backSprite);
					fightUiHelper = new FightUIHelper();
					this.addChild(fightUiHelper);
					topUIHelper = new TopInfoHelper();
					this.addChild(topUIHelper);
					break;
				case HOME_UI:
					//主城的ui
					if(homeContent != null)
					{
						homeContent.destory();
						homeContent = null;
					}
					if(homeContent == null)
					{
						homeContent = new Home();
						homeContent.init();
					}
					this.addChild(homeContent);
					topUIHelper = new TopInfoHelper();
					this.addChild(topUIHelper);
					topUIHelper.topInfoUi.mc_deadLineTimer.visible = false;
					friendList = new FriendsListHelper();
					this.addChild(friendList);
					menuBar = new MainMenuBar();
					this.addChild(menuBar);
					taskList = new TaskListHelper();
					this.addChild(taskList);
					messageActive = new MessageAndActive();
					messageActive.x = 900;
					messageActive.y = 10;
					this.addChild(messageActive);
					break;
				case FRIEND_HOME:
					friendHome = new FriendHome();
					friendHome.installData(rest[0] as FriendDetailInfo);
					this.addChild(friendHome);
					topUIHelper = new TopInfoHelper();
					this.addChild(topUIHelper);
					topUIHelper.topInfoUi.mc_deadLineTimer.visible = false;
					friendList = new FriendsListHelper();
					this.addChild(friendList);
					menuBar = new MainMenuBar();
					this.addChild(menuBar);
					taskList = new TaskListHelper();
					this.addChild(taskList);
					messageActive = new MessageAndActive();
					messageActive.x = 900;
					messageActive.y = 10;
					this.addChild(messageActive);
					break;
				default:
					break;
			}
			//添加上设置
			settingUIHelper = new SettingHelper();
			this.addChild(settingUIHelper);
			EffectUtil.showSwitchViewEffect(this.stage,ConfigManager.GAME_WIDTH,ConfigManager.GAME_HEIGHT);
		}
	}
} 
