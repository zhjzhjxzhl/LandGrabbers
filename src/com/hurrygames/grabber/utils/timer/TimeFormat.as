package com.hurrygames.grabber.utils.timer
{
	import flash.utils.getTimer;
	/**
	 *此类是一个时间格式化类
	 * 		formatToHMS函数用于将一个毫秒值格式化为一个  小时：分钟：秒   格式的字符串 
	 * @author zhaojun.jun
	 * 
	 */	
	public class TimeFormat
	{
		public function TimeFormat()
		{
		}
		//传入一个毫秒值，将其转化为   小时：分钟：秒   的字符串形式。
		// 进行此格式化 1000次，需要4毫秒，对效率不会有影响
		/**
		 *  /传入一个毫秒值，将其转化为   小时：分钟：秒   的字符串形式。
		 *	 进行此格式化 1000次，需要4毫秒，对效率不会有影响
		 * @param microSeconds
		 * @return 
		 * 
		 */		
		public static function formatToHMS(microSeconds:Number):String
		{
			var seconds:int = int(microSeconds/1000);
			var s:Array = ["0","0",":","0","0",":","0","0"];
			s[0] = int(seconds/36000);
			s[1] = int(seconds/3600)%10;
			s[3] = int((seconds%3600)/600);
			s[4] = int((seconds%3600)/60)%10;
			s[6] = int((seconds%60)/10);
			s[7] = seconds%10;
			return ""+s[0]+s[1]+s[2]+s[3]+s[4]+s[5]+s[6]+s[7];
		}
	}
}