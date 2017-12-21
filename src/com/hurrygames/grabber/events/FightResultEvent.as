package com.hurrygames.grabber.events
{
	import flash.events.Event;
	
	
	/**
	 * Project : LandGrabbers
	 * FightResultEvent
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class FightResultEvent extends Event
	{
		/**
		 * 战斗玩家胜利 
		 */		
		public static const FIGHT_PLAYER_WIN:String = "fightPlayerWin";
		
		/**
		 * 战斗玩家失败 
		 */		
		public static const FIGHT_PLAYER_LOSE:String = "fightPlayerLose";
		
		public function FightResultEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
} 
