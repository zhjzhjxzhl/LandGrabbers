package com.hurrygames.grabber.config
{
	import flash.geom.Point;
	
	/**
	 * Project : LandGrabbers
	 * AnimationModel
	 * 动画资源的数据模型类。
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Animation extends BaseModel
	{
		/**
		 * 动画的名称 
		 */		
		public var name:String;
		
		/**
		 * 动画开始于那一帧 
		 */		
		public var start_frame:int;
		
		/**
		 * 动画结束于那一帧 
		 */		
		public var end_frame:int;
		
		/**
		 * 动画持续的时间 
		 */		
		public var animation_time:Number;
		
		/**
		 * 动画的帧大小。 
		 */		
		public var frame_size:Point;
		
		/**
		 * 动画所在图片的名字 
		 */		
		public var texname:String;
		
		/**
		 * 发光 
		 */		
		public var glow:Boolean;
		
		/**
		 *  动画的增量
		 */		
		public var delta_pos:Point = new Point(0,0);
		
		/**
		 * 是否平滑 
		 */		
		public var smooth:Boolean;
		
		/**
		 * 缩放参数 
		 */		
		public var scale_factor:Number = 1;
		
		/**
		 * 不知道。。 
		 */		
		public var frame_scale:Point = new Point(1,1);
		
		/**
		 * 是否随机化。 
		 */		
		public var randomize:Boolean;
		
		public function Animation(string:String)
		{
			super(string)
		}
	}
} 
