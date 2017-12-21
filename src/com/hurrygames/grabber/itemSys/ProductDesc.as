package com.hurrygames.grabber.itemSys
{
	
	/**
	 * Project : LandGrabbers
	 * ProductDesc
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ProductDesc extends ItemDesBase
	{
		public var product_id:int;
		public var product_name:String;
		public var product_desc:String;
		public var prodcut_icon:String;
		public var product_pirce:int;
		public var currency_type:int;
		public var allow_merge_count:int;
		public var product_effect:String;
		public var status:int;
			
		public function ProductDesc()
		{
		}
	}
} 
