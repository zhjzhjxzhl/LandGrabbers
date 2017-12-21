package com.hurrygames.grabber.ui.part
{
	import com.hurrygames.grabber.managers.FightTimerController;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.utils.timer.TimeFormat;
	import com.hurrygames.landgrabber.swc.FightUI.TopInfo;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	public class TopInfoHelper extends BaseObject
	{
		private var _changeWatchers:Vector.<ChangeWatcher>;
		
		private var _topInfo:TopInfo;
		public function TopInfoHelper()
		{
			super();
			_topInfo = new TopInfo();
			_topInfo.x = -3;
			_topInfo.y = -2;
			this.addChild(_topInfo);
		}
		
		public function get topInfoUi():TopInfo
		{
			return _topInfo;
		}
		
		override protected function destory():void
		{
			super.destory();
			FightTimerController.instance.callBack = null;
			while(_changeWatchers.length>0)
			{
				_changeWatchers.pop().unwatch();
			}
			_changeWatchers = null;
		}
		
		override protected function init():void
		{
			super.init();
			_changeWatchers = new Vector.<ChangeWatcher>();
			_changeWatchers.push(BindingUtils.bindProperty(_topInfo.mc_coinInfo.txt_diamond,"text",UserProfile.instance.userData,"gold"/*"diamond"*/));
			_changeWatchers.push(BindingUtils.bindProperty(_topInfo.mc_energyInfo.txt_energy,"text",UserProfile.instance.userData,"energy"));
			_topInfo.mc_headNameInfo.txt_level.text = UserProfile.instance.userData.level.toString();
			_topInfo.mc_headNameInfo.txt_userName.text = UserProfile.instance.userData.name;
			
			FightTimerController.instance.callBack = setTime;
			
		}
		private function setTime(time:Number):void
		{
			_topInfo.mc_deadLineTimer.txt_UsedTime.text = TimeFormat.formatToHMS(time*1000);
		}
		
	}
}