package com.hurrygames.grabber.vo.home
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class PeopleVO extends BaseVO
	{
		/**
		 *居民的名字 
		 */		
		public var peopleName:String;
		/**
		 *居民的avatar类型。 
		 */		
		public var peopleAvatar:int;
		
		public function PeopleVO(o:Object)
		{
			super(o);
		}
	}
}