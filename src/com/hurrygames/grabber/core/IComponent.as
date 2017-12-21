package com.hurrygames.grabber.core
{
	public interface IComponent
	{
		function set Entity(entity:IEntity):void;
		
		function init(para:*):void;
		
		/**
		 * 加入深度或者浅析构。为了反复使用。 
		 * @param deep
		 * 
		 */	
		function destory(deep:Boolean = true):void;
	}
}