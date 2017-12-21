package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.swc.MainUI.UIBigAreaSelector;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	
	/**
	 * Project : LandGrabbers
	 * BigAreaHelper
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class BigAreaHelper extends BaseObject
	{
		private var _bigSelector:UIBigAreaSelector;
		
		public var _smallArea:SmallAreaHelper;
		
		public function BigAreaHelper()
		{
			super();
		}
		
		override protected function destory():void
		{
			// TODO Auto Generated method stub
			this.removeChild(_bigSelector);
			_bigSelector = null;
		}
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			
			_bigSelector = new UIBigAreaSelector();
			_bigSelector.mc_Fire.mouseChildren = _bigSelector.mc_Fire.mouseEnabled = false;
			this.addChild(_bigSelector);
			setBigStep(UserProfile.instance.userProgress.bigAreaIndex);
			_smallArea = new SmallAreaHelper();
			this.addChild(_smallArea);
			
			for(var i:int = 0;i<5;i++)
			{
				_bigSelector["btn_BigArea"+i].addEventListener(MouseEvent.CLICK,showArea);
			}
		}
		
		private function showArea(e:MouseEvent):void
		{
			var simpleB:SimpleButton = e.currentTarget as SimpleButton;
			var index:int = int(simpleB.name.charAt(simpleB.name.length-1));
			_smallArea.showArea(index);
		}
		
		/**
		 * 设置大地图进行到了第几个区域 
		 * @param bigStep 0-4
		 * 
		 */		
		public function setBigStep(bigStep:int):void
		{
			for(var i:int = 0;i<5;i++)
			{
				_bigSelector["btn_BigArea"+i].visible = false;
			}
			for(var j:int = 0;j<=bigStep;j++)
			{
				_bigSelector["btn_BigArea"+j].visible = true;
			}
		}
		
	}
} 
