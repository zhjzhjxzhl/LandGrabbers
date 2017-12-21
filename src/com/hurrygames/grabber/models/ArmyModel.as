package com.hurrygames.grabber.models
{
	import com.hurrygames.grabber.config.Path_count_node;
	import com.hurrygames.grabber.core.IEntity;
	import com.hurrygames.grabber.core.IModel;
	import com.hurrygames.grabber.managers.ResourceManager;
	
	import flash.geom.Point;
	
	public class ArmyModel implements IModel
	{
		/**
		 * 此军队的路径 
		 */		
		public var path:Vector.<Path_count_node>;
		
		/**
		 * 军队的人数。 
		 */		
		public var armyPopulation:int;
		
		/**
		 * 当前的位置，第一个。 
		 */		
		public var currentPosition:Point;
		
		/**
		 * 当前的速度。第一个.
		 */		
		public var speed:Point;
		
		public function ArmyModel()
		{
		}
		
		public function set Entity(entity:IEntity):void
		{
		}
		
		public function init(para:*):void
		{
		}
		
		public function destory(deep:Boolean = true):void
		{
			while(path.length > 0)
			{
				path.pop();
			}
			path = null;
//			ResourceManager.instance.releaseResource(currentPosition);
//			ResourceManager.instance.releaseResource(speed);
			currentPosition = null;
			speed = null;
			armyPopulation = 0;
		}
	}
}