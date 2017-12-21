package com.hurrygames.grabber.vo.storage
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	public class StorageItem extends BaseVO
	{
		/**
		 *存储的类型，product和equipment 
		 */
		public var type:String;
		
		/**
		 * 
		 */
		public var data:StorageDetail
		
		public function StorageItem(o:Object)
		{
			super(o);
		}
	}
}