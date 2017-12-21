package com.hurrygames.grabber.vo.map
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * MasterRecord
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class MasterRecord extends BaseVO
	{
		/**
		 *id 
		 */
		public var uid:int;
		
		/**
		 *头像 
		 */
		public var imgurl:String;
		
		/**
		 * 过关时间 
		 */
		public var passTime:int;
		/**
		 * 
		 * @param o
		 * 
		 */		
		public function MasterRecord(o:Object)
		{
			super(o);
		}
	}
} 
