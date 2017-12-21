package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.swc.MainUI.DialoguePlayersRank;
	
	import flash.events.MouseEvent;
	
	import gs.TweenLite;
	
	
	/**
	 * Project : LandGrabbers
	 * UserRankPanelHelper
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class UserRankPanelHelper extends BaseObject
	{
		private var _rankDialogue:DialoguePlayersRank;
		
		public function UserRankPanelHelper()
		{
			super();
		}
		
		override protected function destory():void
		{
			// TODO Auto Generated method stub
			
		}
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			_rankDialogue = new DialoguePlayersRank();
			this.addChild(_rankDialogue);
			
			//初始化事件
			_rankDialogue.btn_Close.addEventListener(MouseEvent.CLICK,closePanel);
			
			//做初始滑动。
			_rankDialogue.x = (ConfigManager.GAME_WIDTH-_rankDialogue.width)/2;
			_rankDialogue.y = (ConfigManager.GAME_HEIGHT - _rankDialogue.height)/2;
			TweenLite.from(_rankDialogue,0.5,{y:-_rankDialogue.height,alpha:0.5});
		}
		
		protected function closePanel(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var self:UserRankPanelHelper = this;
			TweenLite.to(_rankDialogue,0.5,{y:-_rankDialogue.height,alpha:0.5,onComplete:function():void
			{
				POPUpManager.instance.removePop(self);
			}
			});
		}		
		
	}
} 
