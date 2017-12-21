package com.hurrygames.grabber.managers
{
	public class VersionConfig
	{
		/**
		 * 当前的版本号 
		 */		
		public static var Version:int = 0;
		
		public function VersionConfig()
		{
		}
		
		public static function getVersionString():String
		{
			return ("?v="+Version);
		}
	}
}