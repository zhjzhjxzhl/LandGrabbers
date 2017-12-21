package com.hurrygames.grabber.models
{
	import com.hurrygames.grabber.config.Warzone;
	import com.hurrygames.grabber.core.IEntity;
	import com.hurrygames.grabber.core.IModel;
	
	
	/**
	 * Project : LandGrabbers
	 * WarzoneModel
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class WarzoneModel extends Warzone implements IModel
	{
		public function WarzoneModel(string:String)
		{
			super(string);
		}
		
		public function set Entity(entity:IEntity):void
		{
		}
		
		public function init(para:*):void
		{
		}
		
		public function destory(deep:Boolean = true):void
		{
			lineString = null;
		}
	}
} 
