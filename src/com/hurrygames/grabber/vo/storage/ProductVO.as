package com.hurrygames.grabber.vo.storage
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * ProductVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ProductVO extends BaseVO
	{
		/**
		 * 物品的拥有者 
		 */
		public var uid:int;
		/**
		 * 产品的类型。 
		 */
		public var product_typeId:int;
		
		/**
		 * 个数 
		 */
		public var product_num:int;
		
		public function ProductVO(o:Object)
		{
			super(o);
		}
	}
} 
