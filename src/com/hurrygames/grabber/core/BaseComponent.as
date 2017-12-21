package com.hurrygames.grabber.core
{
	
	/**
	 * Project : LandGrabbers
	 * BaseComponent
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class BaseComponent implements IComponent
	{
		protected var _entity:IEntity;
		
		public function BaseComponent()
		{
		}
		
		public function set Entity(entity:IEntity):void
		{
			_entity = entity;
		}
		
		public function init(para:*):void
		{
			
		}
		
		public function destory(deep:Boolean = true):void
		{
			
		}
	}
} 
