package com.hurrygames.grabber.logics
{
	import com.hurrygames.grabber.core.BaseLogic;
	import com.hurrygames.grabber.core.IEntity;
	import com.hurrygames.grabber.core.ILogic;
	
	
	/**
	 * Project : LandGrabbers
	 * TimerCallLogic
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class TimerCallLogic extends BaseLogic
	{
		/**
		 * 回调函数 
		 */		
		private var _callBack:Function;
		
		/**
		 * 隔多少时间回调。毫秒数。 
		 */		
		private var _times:Number;
		
		private var _currentTimes:Number = 0;
		
		private var _pause:Boolean = false;
		
		/**
		 * 一个在固定毫秒数回调的逻辑类。
		 * @param times 毫秒数
		 * @param callBack 回调函数
		 * 
		 */		
		public function TimerCallLogic(times:Number = 1000,callBack:Function=null)
		{
			super();
			_times = times;
			_callBack = callBack;
			_currentTimes = 0;
		}
		
		/**
		 * tick 的时间。 
		 * @param delTime
		 * 
		 */		
		override public function onTick(delTime:Number):void
		{
			_currentTimes += delTime;
			if(_currentTimes >= _times)
			{
				(!_pause)&&(callBack());
				_currentTimes -= _times;
			}
		}
		
		/**
		 * 回调函数。 
		 * 
		 */		
		protected function callBack():void
		{
			if(_callBack != null)
			{
				_callBack.apply();
			}
		}
		
		/**
		 * 暂停逻辑 
		 * 
		 */		
		public function pause():void
		{
			_pause = true;
		}
		
		/**
		 * 重启逻辑 
		 * 
		 */		
		public function resume():void
		{
			_pause = false;
		}
		
		override public function destory(deep:Boolean=true):void
		{
			_callBack = null;
			_pause = false;
			_currentTimes = 0;
			super.destory(deep);
		}
	}
} 
