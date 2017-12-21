package com.hurrygames.grabber.vo.map
{
	import com.hurrygames.grabber.vo.BaseVO;
	import com.hurrygames.grabber.vo.master.RecordVO;
	
	
	/**
	 * Project : LandGrabbers
	 * OneLevelMasterInfo
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class OneLevelMasterInfo extends BaseVO
	{
		/**
		 *普通难度 
		 */
		public var normalMaster:RecordVO;
		
		/**
		 *高端难度 
		 */
		public var hardMaster:RecordVO;
		
		/**
		 * 超级难度 
		 */
		public var veryHardMaster:RecordVO;
		
		public function OneLevelMasterInfo(o:Object)
		{
			super(o);
		}
	}
} 
