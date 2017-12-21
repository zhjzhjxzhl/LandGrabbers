package com.hurrygames.grabber.utils.timer
{
	/**
	 *此类事一个时间计数器，在到达指定时间后，会进行一次回调。 
	 * @author zhaojun.jun
	 * 
	 */	
	public class DeadLineTimer
	{
		/**
		 * 
		 * @param time 时间数，以 秒 为单位
		 * @param finishCallback 到达时间之后的回调函数。
		 * @param secondCallback 每秒的回调函数。用于将当前结果字符串返回给使用者。 此函数接收一个hh:mm:ss表示的字符串作为参数
		 * @param secondCallBackWithSecond 每秒的回调函数。返回的是剩余的毫秒数.
		 */		
		public function DeadLineTimer(time:Number,finishCallback:Function,secondCallback:Function=null,secondCallBackWithSecond:Function=null)
		{
			_time = time * 1000;
			_callback = finishCallback;
			_secondcallback = secondCallback;
			_secondCBWS = secondCallBackWithSecond;
		}
		private var _doing:Boolean = false;
		public function start():void
		{
			if(!_doing)
			{
				TimerManager.instance.addSecondListener(oneSecondPassed);
				_doing = true;
			}
		}
		private var _time:Number;
		private var _callback:Function;
		private var _secondcallback:Function;
		private var _secondCBWS:Function;
		//已经经过的时间。
		private var _passedTime:Number = 0;
		private function oneSecondPassed(t:int):void
		{
			_passedTime += t;
			if(_passedTime<=_time)
			{
				if(_secondcallback != null)
				{
					_secondcallback.call(null,TimeFormat.formatToHMS(_time - _passedTime));
				}
				if(_secondCBWS!=null)
				{
					_secondCBWS.call(null,(_time - _passedTime));
				}
			}
			if(_passedTime >= _time)
			{
				if(_callback!=null)
					_callback.apply();
				TimerManager.instance.removeSecondListener(oneSecondPassed);
			}
		}
		
		/**
		 * 返回的是一个距离结束还有的秒数. 
		 * @return 
		 * 
		 */		
		public function lastSeconds():Number
		{
			return ((_time - _passedTime)/1000);
		}
		public function destory():void
		{
			TimerManager.instance.removeSecondListener(oneSecondPassed);
			_doing = false;
		}

	}
}