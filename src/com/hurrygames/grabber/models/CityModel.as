package com.hurrygames.grabber.models
{
	import com.hurrygames.grabber.config.City;
	import com.hurrygames.grabber.core.IEntity;
	import com.hurrygames.grabber.core.IModel;
	
	
	/**
	 * Project : LandGrabbers
	 * CityModel
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class CityModel extends City implements IModel
	{
		/**
		 *选择目标城市的时候，此值越小，就选择此值。 
		 */
		public var selectedNumber:Number = -1;
		
		/**
		 *当前的人口 
		 */
		public var current_population:Number;
		
		public function CityModel(string:String)
		{
			super(string);
			current_population = start_population;
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
