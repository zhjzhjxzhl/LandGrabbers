package com.hurrygames.grabber.config
{
	import flash.geom.Point;
	
	/**
	 * Project : LandGrabbers
	 * Obstacle
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Obstacle extends BaseModel
	{
		
		public var name:String;
		
		/**
		 * 初始位置 
		 */		
		public var pos:Point;
		
		public var y_point:Number;
		
		/**
		 * 资源名 
		 */		
		public var texture:String;
		
		
		public var p0:Point;
		
		public var p1:Point;
		
		public var p2:Point;
		
		public var p3:Point;
		
		/**
		 * 层次，都是-1 
		 */		
		public var layer:int;
		
		/**
		 * 是否移动 
		 */		
		public var sliding:Boolean;
		
		/**
		 * 移动的速度。 
		 */	 	
		public var slide_speed:Point;
		
		public function Obstacle(string:String)
		{
			super(string);
		}
	}
} 
