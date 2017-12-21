package com.hurrygames.grabber.ui.part
{
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.ui.panel.MessagePanelHelper;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.landgrabber.swc.HomeUI.ActivityButton;
	import com.hurrygames.landgrabber.swc.HomeUI.MessageButton;
	
	import flash.events.MouseEvent;
	
	public class MessageAndActive extends BaseObject
	{
		private var _messageButton:MessageButton;
		private var _activeButton:ActivityButton;
		
		public function MessageAndActive()
		{
			super();
		}
		
		override protected function destory():void
		{
			// TODO Auto Generated method stub
			super.destory();
			_messageButton.removeEventListener(MouseEvent.CLICK,showMessage);
			_activeButton.removeEventListener(MouseEvent.CLICK,showActive);
		}
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			super.init();
			_messageButton = new MessageButton();
			_activeButton = new ActivityButton();
			this.addChild(_messageButton);
			this.addChild(_activeButton);
			_activeButton.x = 50;
			_activeButton.y = -3;
			
			_messageButton.addEventListener(MouseEvent.CLICK,showMessage);
			_activeButton.addEventListener(MouseEvent.CLICK,showActive);
		}
		
		protected function showMessage(event:MouseEvent):void
		{
			var messagePH:MessagePanelHelper =new MessagePanelHelper();
			POPUpManager.instance.showPop(messagePH,true);
		}
		
		protected function showActive(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
	}
}