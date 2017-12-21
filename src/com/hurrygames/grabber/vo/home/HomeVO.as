package com.hurrygames.grabber.vo.home
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class HomeVO extends BaseVO
	{
		/**
		 * 获取信息的成功和失败 
		 */		
		public var code:int;
		
		/**
		 * 城堡等级 
		 */		
		public var castleLevel:int;
		/**
		 * 城堡当前的建设度
		 */		
		public var castleBuildProgress:int;
		/**
		 * 城堡升级需要的建设度
		 */		
		public var castleNeedBuild:int;
		/**
		 * 城堡目前目前的能量
		 */		
		public var castleEnergy:int;
		/**
		 * 城堡此次征收需要的最大能量
		 */		
		public var castleNeedEnergy:int;
		/**
		 * 城堡征收可获得的金币。
		 */		
		public var castleGetCoin:int;
		/**
		 * 城堡的名字，如果需要
		 */		
		public var castleName:String;
		/**
		 *装饰的信息 
		 */		
		public var decorations:Vector.<Decoration>;
		/**
		 *居民的信息，如果有的话。 
		 */		
		public var peoples:Vector.<PeopleVO>;
		
		
		public function HomeVO(o:Object)
		{
			super(o);
		}
	}
}