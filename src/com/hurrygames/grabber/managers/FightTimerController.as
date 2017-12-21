package com.hurrygames.grabber.managers
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * Project : LandGrabbers
	 * FightTimerController 战斗计时的一个类.
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class FightTimerController
	{
		/**
		 * 战斗用时 
		 */		
		private var _time:Number = 0;
		
		private var _timer:Timer;
		
		/**
		 * 一个回调函数，接收一个秒数，作为 
		 * @return 
		 * 
		 */		
		public var callBack:Function;
		
		private static var _instance:FightTimerController;
		public static function get instance():FightTimerController
		{
			if(_instance == null)
			{
				_instance = new FightTimerController();
			}
			return _instance;
		}
		
		public function FightTimerController()
		{
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER,oneSecend);
		}
		
		protected function oneSecend(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			_time += 1;
			if(callBack != null)
			{
				callBack(_time/10);
			}
		}
		
		public function reset():void
		{
			_time = 0;
		}
		
		public function stop():void
		{
			_timer.stop();
		}
		
		public function start():void
		{
			_timer.start();
		}
		
		/**
		 * 获取上一场战斗记录的时间。 秒数。
		 * @return 
		 * 
		 */		
		public function get time():Number
		{
			return (_time/10);
		}
	}
} 
