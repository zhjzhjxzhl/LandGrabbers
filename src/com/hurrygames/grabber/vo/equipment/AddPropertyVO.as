package com.hurrygames.grabber.vo.equipment
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class AddPropertyVO extends BaseVO
	{
		/**
		 * 本条附加属性的类型
		 */		
		public var propertyType:int;
		/**
		 * 本条附加属性的值，此值是在一个配置范围内的随机值。
		 */		
		public var propertyValue:int;

		public function AddPropertyVO(o:Object)
		{
			super(o);
		}
	}
}