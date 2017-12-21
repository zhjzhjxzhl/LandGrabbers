package com.hurrygames.grabber.vo.master
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	
	/**
	 * Project : LandGrabbers
	 * RecordVO
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class RecordVO extends BaseVO
	{
		/**
		 * 用户id 
		 */		
		public var uid:int;
		
		/**
		 * 用户头像 
		 */		
		public var imgurl:String;
		
		/**
		 *用户过关时间 
		 */		
		public var passTime:int;
		
		/**
		 * 用户名字 
		 */		
		public var name:String;
		
		public function RecordVO(obj:Object=null)
		{
			super(obj);
		}
	}
} 
