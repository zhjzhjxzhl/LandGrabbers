package com.hurrygames.grabber.vo.home
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class Decoration extends BaseVO
	{
		/**
		 * 装饰的id
		 */		
		public var id:int;
		/**
		 * 装饰的X值。
		 */		
		public var x:Number;
		/**
		 * 装饰的Y值
		 */		
		public var y:Number;
		/**
		 * 装饰的颜色转换，如果需要
		 */		
		public var color:uint;
		/**
		 * 装饰的类型
		 */		
		public var type:int;

		public function Decoration(o:Object)
		{
			super(o);
		}
	}
}