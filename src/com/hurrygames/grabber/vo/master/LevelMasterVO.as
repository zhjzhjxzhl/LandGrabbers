package com.hurrygames.grabber.vo.master
{
	import com.hurrygames.grabber.vo.BaseVO;
	
	/**
	 * Project : LandGrabbers
	 * LevelMaster
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class LevelMasterVO extends BaseVO
	{
		/**
		 * 此关的普通擂主 
		 */		
		public var normalMaster:RecordVO;
		
		/**
		 * 此关的高端擂主 
		 */		
		public var hardMaster:RecordVO;
		
		/**
		 * 此关的传奇擂主 
		 */		
		public var veryHardMaster:RecordVO;
		
		public function LevelMasterVO()
		{
		}
	}
} 
