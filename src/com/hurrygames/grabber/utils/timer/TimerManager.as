package com.hurrygames.grabber.utils.timer
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class TimerManager
	{
		
		///--------------------------------------------------///
		public function get ServerTime():Number
		{
			return int((_startT+(flash.utils.getTimer()-_startLocal)/1000));
		}
		public function set ServerTime(t:Number):void
		{
			_startT = t;
			_startLocal = flash.utils.getTimer();
		}
		private var _startT:Number = 0;
		private var _startLocal:Number = 0;
		///--------------------------------------------------///
		private static var _instance:TimerManager;
		public static function get instance():TimerManager
		{
			if(_instance == null)
			{
				_instance = new TimerManager();
			}
			return _instance;
		}
		private var _s:Shape;
		public function TimerManager()
		{
			_s = new Shape();
			_s.addEventListener(Event.ENTER_FRAME,isOneSecond);
			_lastTime = flash.utils.getTimer();
		}
		private function isOneSecond(e:Event):void
		{
			var time:int = int(flash.utils.getTimer() - _lastTime);
			if(time > 1000)
			{
				_lastTime = flash.utils.getTimer();
				secondTick(time);
			}
		}
		private var _listeners:Array = [];
		/**
		 *添加一个每秒的监听，当有一秒过去的时候，会遍历此中事件。 
		 * @param f 此处函数的参数格式应该是接收一个number类型的参数，此参数表明此次调用和上次调用具体的时间差的毫秒数。
		 * 此毫秒数将按照虚拟机的毫秒数进行计算。
		 * 
		 */		
		public function addSecondListener(f:Function):void
		{
			_listeners.push(f);
		}
		public function removeSecondListener(f:Function):void
		{
			if(_listeners.indexOf(f)!=-1)
			{
				_listeners.splice(_listeners.indexOf(f),1);
			}
		}
		//上次调度 secondtick时，虚拟机已经启动的时间。
		private var _lastTime:Number;
		private function secondTick(time:int):void
		{
			for each(var f:Function in _listeners)
			{
				//函数f接收一个参数，此参数表示从上次调用到这次调用虚拟机经过的毫秒数。
				f.apply(null,[time]);
			}
		}

	}
}