package com.hurrygames.grabber.utils
{
	import com.hurrygames.grabber.config.Animation;
	import com.hurrygames.grabber.managers.ResourceManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * Project : LandGrabbers
	 * SoldierAnimation
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class SoldierAnimation extends AnimationRender
	{
		public function SoldierAnimation(am:Animation, bitmapdata:BitmapData,animationName:String)
		{
			super(am,bitmapdata,animationName);
		}
		
//		override protected function initBitmapdata():void
//		{
//			
//		}
		
		/**
		 * 覆盖了父的，将两步copyPixel变为一步pixel。军队的数量多，简化此步骤.
		 * 
		 */		
//		override protected function lp():void
//		{
//			_lastTimefromPreFrame += 40;
//			if(_lastTimefromPreFrame < frameTime)
//			{
//				return;
//			}else
//			{
//				var lastFrames:int = int(_lastTimefromPreFrame/frameTime);
//				_lastTimefromPreFrame -= lastFrames*frameTime;
//				_currentFrame += lastFrames;
//				if(_currentFrame >= frames)
//				{
//					if(AnimationFinishedCallBack != null)
//					{
//						AnimationFinishedCallBack.apply();
//						AnimationFinishedCallBack = null;
//					}
//				}
//			}
//		}
		
		/**
		 * 由于lp方法不渲染，在此处将显示渲染到父对象上。 
		 * @param parentBitmap
		 * @param rect
		 * 
		 */		
//		public function render(parentBitmap:Bitmap):void
//		{
//			_currentFrame %= frames;
//			var x1:Number = ((_currentFrame+startFrame) % frameWidth)*am.frame_size.x;
//			var y1:Number = int(((_currentFrame+startFrame)/frameWidth))*am.frame_size.y;
//			
//			var p:Point = new Point(am.delta_pos.x+this.x+128,am.delta_pos.y+this.y+128) as Point;
//			parentBitmap.bitmapData.copyPixels(bd,(new Rectangle(x1,y1,am.frame_size.x,am.frame_size.y)),p,null,null,true);
////			ResourceManager.instance.releaseResource(p);
//		}
		
		private var _currentSpeed:Point;
		
		public function setSpeed(speed:Point):void
		{
			if(_currentSpeed && (_currentSpeed.x == speed.x) && (_currentSpeed.y == speed.y))
			{
				return;
			}
			_currentSpeed = new Point(speed.x,speed.y);
			var angle:Number = Math.atan2(speed.y,speed.x)*180/Math.PI;
			
			//回退每个角度的一半。360/16 = 22.5;每个方向的角度范围.
			angle += 22.5/2;
			
			if(angle < 0)
			{
				angle += 360;
			}
			
			var index:int = int(angle/22.5);
			startFrame = index*frames;
			endFrame = startFrame+(frames-1);
			
		}
		
		public function get currentSpeed():Point
		{
			return _currentSpeed;
		}
	}
} 
