package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.landgrabber.swc.HomeUI.GoHomeButton;
	import com.hurrygames.swc.MainUI.UIAllMainUI;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import com.hurrygames.grabber.ui.panel.SkillPanelHelper;
	
	public class SelecteUIHelper extends BaseObject
	{
		/**
		* 主ui 
		*/		
		private var _allUI:UIAllMainUI;
		
		private var _changeWatchers:Vector.<ChangeWatcher>;
		
		/**
		 * 大区域选择器 
		 */		
		public var bigArea:BigAreaHelper;
		
		public var gohome:GoHomeButton;
		
		public function SelecteUIHelper()
		{
			super();
		}
		override protected function init():void
		{
			bigArea = new BigAreaHelper();
			this.addChild(bigArea);
			
			_allUI = new UIAllMainUI();
			this.addChild(_allUI);
			
			//给ui绑定值
			
			_changeWatchers = new Vector.<ChangeWatcher>();
			
			_changeWatchers.push(BindingUtils.bindProperty(_allUI.txt_Level,"text",UserProfile.instance.userData,"level"));
			_changeWatchers.push(BindingUtils.bindProperty(_allUI.txt_Experience,"text",UserProfile.instance.userData,"exp"));
			_changeWatchers.push(BindingUtils.bindProperty(_allUI.txt_UserCoin,"text",UserProfile.instance.userData,"gold"));
			_changeWatchers.push(BindingUtils.bindProperty(_allUI.txt_UserDiamond,"text",UserProfile.instance.userData,"diamond"));
			_changeWatchers.push(BindingUtils.bindProperty(_allUI.txt_UserEnergy,"text",UserProfile.instance.userData,"energy"));
			_allUI.txt_UserName.text = UserProfile.instance.userData.name;
			
			var headIcon:Sprite = new Sprite();
			headIcon.name = "headIcon";
			_allUI.addChildAt(headIcon,0);
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest(UserProfile.instance.userData.imgurl));
//			headIcon.addChild(loader);
			
			headIcon.x = headIcon.y = 5;
			gohome = new GoHomeButton();
			gohome.x = 800;
			gohome.y = 500;
			this.addChild(gohome);
			
			initListeners();
		}
		
		protected function goBackToHome(event:MouseEvent):void
		{
			MainUIController.instance.setMode(MainUIController.HOME_UI);
		}
		
		private function destoryListeners():void
		{
			_allUI.btn_ShowUserSkill.removeEventListener(MouseEvent.CLICK,showSkillPanel);
			_allUI.btn_ShowBigAreaSelector.removeEventListener(MouseEvent.CLICK,showBigArea);
			_allUI.btn_ShowPlayersRank.removeEventListener(MouseEvent.CLICK,showPlayersRank);
			gohome.removeEventListener(MouseEvent.CLICK,goBackToHome);
		}
		
		private function initListeners():void
		{
			// TODO Auto Generated method stub
			_allUI.btn_ShowUserSkill.addEventListener(MouseEvent.CLICK,showSkillPanel);
			_allUI.btn_ShowBigAreaSelector.addEventListener(MouseEvent.CLICK,showBigArea);
			_allUI.btn_ShowPlayersRank.addEventListener(MouseEvent.CLICK,showPlayersRank);
			gohome.addEventListener(MouseEvent.CLICK,goBackToHome);
			
		}
		
		protected function showPlayersRank(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			POPUpManager.instance.showPop(new UserRankPanelHelper());
		}
		
		protected function showBigArea(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			bigArea._smallArea.hideSmallArea();
		}
		
		protected function showSkillPanel(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			POPUpManager.instance.showPop(new SkillPanelHelper());
		}		
		
		override protected function destory():void
		{
			destoryListeners();
//			var h:Sprite = _allUI.getChildByName("headIcon") as Sprite;
//			var l:Loader = h.getChildAt(0) as Loader;
//			l.unloadAndStop();
			
			while(_changeWatchers.length > 0)
			{
				_changeWatchers.pop().unwatch();
			}
			this.removeChild(_allUI);
			_allUI = null;
		}
		
		
	}
}