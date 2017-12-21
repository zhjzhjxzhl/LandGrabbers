package com.hurrygames.grabber.managers
{
	import com.hurrygames.grabber.events.CityEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 * 占领一个城市 
	 */	
	[Event(name="seizeOneCity",type="com.hurrygames.grabber.events.CityEvent")]
	
	/**
	 * 玩家获胜 
	 */	
	[Event(name="fightPlayerWin",type="com.hurrygames.grabber.events.FightResultEvent")]
	
	/**
	 * 玩家失败
	 */	
	[Event(name="fightPlayerLose",type="com.hurrygames.grabber.events.FightResultEvent")]
	
	/**
	 * Project : LandGrabbers
	 * CenterEventDispatcher
	 * 此类是一个全局事件传播器 。主要用来抛出一系列全局事件，来协调各个模块。
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */	
	public class CenterEventDispatcher extends EventDispatcher
	{
		private static var _instance:CenterEventDispatcher;
		public static function get instance():CenterEventDispatcher
		{
			if(_instance == null)
			{
				_instance = new CenterEventDispatcher();
			}
			return _instance;
		}
		public function CenterEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
			if(_instance)
			{
				throw new Error("CenterEventDispatcher 是个单例，通过CenterEventDispatcher.instance来获取实例");
			}
		}
	}
} 
