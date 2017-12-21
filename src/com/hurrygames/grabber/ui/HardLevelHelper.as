package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.swc.MainUI.UIHardModeSelector;
	
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class HardLevelHelper extends BaseObject
	{
		private var _hardLevel:UIHardModeSelector;
		
		/**
		 *选择的难度。默认选择难度1.普通难度 ,1-3
		 */		
		public var selectedModel:int = 1;
		
		/**
		 * 此组件属于的smallArea。 
		 */		
		private var _ownerSAH:SmallAreaHelper;
		
		public function HardLevelHelper(sah:SmallAreaHelper)
		{
			_ownerSAH = sah;
			super();
			_hardLevel = new UIHardModeSelector();
			this.addChild(_hardLevel);
		}
		
		override protected function destory():void
		{
			// TODO Auto Generated method stub
			_hardLevel.btn_Close.removeEventListener(MouseEvent.CLICK,close);
			_hardLevel.btn_StartGame.removeEventListener(MouseEvent.CLICK,startOneLevel);
			_hardLevel.mc_Hard.removeEventListener(MouseEvent.CLICK,selecteHard);
			_hardLevel.mc_Normal.removeEventListener(MouseEvent.CLICK,selecteNormal);
			_hardLevel.mc_VeryHard.removeEventListener(MouseEvent.CLICK,selecteVeryHard);
			
		}
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			_hardLevel.btn_Close.addEventListener(MouseEvent.CLICK,close);
			_hardLevel.btn_StartGame.addEventListener(MouseEvent.CLICK,startOneLevel);
			_hardLevel.mc_Hard.addEventListener(MouseEvent.CLICK,selecteHard);
			_hardLevel.mc_Normal.addEventListener(MouseEvent.CLICK,selecteNormal);
			_hardLevel.mc_VeryHard.addEventListener(MouseEvent.CLICK,selecteVeryHard);
			
			selecteNormal();
		}
		
		private function resetAllSelecte():void
		{
			_hardLevel.mc_Hard.filters = [];
			_hardLevel.mc_Normal.filters = [];
			_hardLevel.mc_VeryHard.filters = [];
		}
		
		protected function selecteVeryHard(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			selectedModel = 3;
			resetAllSelecte();
			_hardLevel.mc_VeryHard.filters = [new GlowFilter(0xffffff,1,8,8,16)];
		}
		
		protected function selecteNormal(event:MouseEvent = null):void
		{
			// TODO Auto-generated method stub
			selectedModel = 1;
			resetAllSelecte();
			_hardLevel.mc_Normal.filters = [new GlowFilter(0xffffff,1,8,8,16)];
		}
		
		protected function selecteHard(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			selectedModel = 2;
			resetAllSelecte();
			_hardLevel.mc_Hard.filters = [new GlowFilter(0xffffff,1,8,8,16)];
		}
		
		protected function startOneLevel(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			_ownerSAH.startUseHardMode(selectedModel);
			close();
		}
		
		public function close(event:MouseEvent=null):void
		{
			// TODO Auto-generated method stub
			if(this.parent)
			{
				this.parent.removeChild(this);
				_ownerSAH = null;
			}
		}		
		
	}
}