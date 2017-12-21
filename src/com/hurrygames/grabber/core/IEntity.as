package com.hurrygames.grabber.core
{
	public interface IEntity
	{
		/**
		 * 添加一个component。每个entity可以有多个逻辑component。
		 * 可以有一个或者多个渲染。
		 * 但是，目前只有一个Model. 
		 * @param component
		 * 
		 */		
		function addComponent(component:IComponent,name:String):void;
		function removeComponentByName(name:String,deep:Boolean = true):void;
		
		function getComponentByName(name:String):IComponent;
		
		function getComponentsByTyep(type:Class):Vector.<IComponent>;
		
		function get Model():IModel;
		
		/**
		 * 加入深度或者浅析构。为了反复使用。 
		 * @param deep
		 * 
		 */		
		function destory(deep:Boolean = true):void;
	}
}