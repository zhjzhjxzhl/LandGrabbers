package com.hurrygames.grabber.utils
{
	import com.hurrygames.grabber.config.Animation;
	import com.hurrygames.grabber.managers.LoopController;
	import com.hurrygames.grabber.managers.ResourceManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class AnimationRender extends Bitmap
	{
		/**
		 * 这个动画的名字，key。为了反复利用此动画。 
		 */		
		public var Aname:String;
		
		protected var am:Animation;
		protected var bd:BitmapData;
		protected var frameTime:Number = 0;
		
		/**
		 * 起始帧 
		 */		
		protected var startFrame:uint = 0;
		protected var endFrame:uint = 0;
		/**
		 * 动画帧数 
		 */		
		protected var frames:uint = 0;
		
		public var AnimationFinishedCallBack:Function;
		
		/**
		 * 将一些动画的资源缓存起来，避免反复调用copypixel。此方法也消耗蛮多。此处里面存储的是bitmapdata。
		 */		
		private var _cachedBitmapdatas:Dictionary;
		
		/**
		 * 所有已经初始化过的动画的字典。此中的类型是AnimationRender
		 */		
		private static var _initAnimation:Dictionary = new Dictionary();
		
		public function AnimationRender(am:Animation,bitmapdata:BitmapData,aniamtionName:String)
		{
			Aname = aniamtionName;
			this.am = am;
			this.bd = bitmapdata;
			start();
			
			
			if(_initAnimation[Aname] != null)
			{
				clone(_initAnimation[Aname] as AnimationRender);
			}else
			{
				this._cachedBitmapdatas = new Dictionary();
				_initAnimation[Aname] = this;
				
				frameTime = (am.animation_time*1000)/(am.end_frame-am.start_frame);
				this.scaleX = am.frame_scale.x;
				this.scaleY = am.frame_scale.y;
				
				startFrame = am.start_frame;
				endFrame = am.end_frame;
				frames = endFrame-startFrame +1;
				frameWidth = int(1024/am.frame_size.x);
			}
			
//			initBitmapdata();
		}
		
		protected function clone(ar:AnimationRender):void
		{
			this._cachedBitmapdatas = ar._cachedBitmapdatas;
			this.frames = ar.frames;
			this.startFrame = ar.startFrame;
			this.endFrame = ar.endFrame;
			this.frameTime = ar.frameTime;
			this.scaleX = ar.scaleX;
			this.scaleY = ar.scaleY;
			this.frameWidth = ar.frameWidth;
		}
		
//		protected function initBitmapdata():void
//		{
//			this.bitmapData = new BitmapData(am.delta_pos.x+am.frame_size.x,am.delta_pos.y+am.frame_size.y,true,0x0);
//		}
		
		protected var frameWidth:uint;
		
		protected var _currentFrame:uint = 0;
		protected var _lastTimefromPreFrame:Number = 0;
		protected function lp(e:Event = null):void
		{
			_lastTimefromPreFrame += 40;
			if(_lastTimefromPreFrame < frameTime)
			{
				return;
			}else
			{
				var lastFrames:uint = uint(_lastTimefromPreFrame/frameTime);
				_lastTimefromPreFrame -= lastFrames*frameTime;
				_currentFrame += lastFrames;
				if(_currentFrame >= frames)
				{
					if(AnimationFinishedCallBack != null)
					{
						AnimationFinishedCallBack.apply();
						AnimationFinishedCallBack = null;
						if(am == null)
						{
							return;
						}
					}
					_currentFrame %= frames;
				}
				var frameKey:uint = _currentFrame+startFrame;
				if(_cachedBitmapdatas[frameKey])
				{
					this.bitmapData = _cachedBitmapdatas[frameKey];
				}else
				{
					this.bitmapData = new BitmapData(am.delta_pos.x+am.frame_size.x,am.delta_pos.y+am.frame_size.y,true,0x0);
					_cachedBitmapdatas[frameKey] = this.bitmapData;
					var x1:Number = ((_currentFrame+startFrame) % frameWidth)*am.frame_size.x;
					var y1:Number = uint(((_currentFrame+startFrame)/frameWidth))*am.frame_size.y;
					
					var rect:Rectangle = new Rectangle(am.delta_pos.x,am.delta_pos.y,am.frame_size.x,am.frame_size.y);
					this.bitmapData.lock();
					var p:Point = (new Point(rect.x,rect.y)) as Point;
					this.bitmapData.copyPixels(bd,(new Rectangle(x1,y1,am.frame_size.x,am.frame_size.y)),p);
					this.bitmapData.unlock();
				}
				//此处验证，主要是有可能上面的回调，会导致此动画的结束。
//				if(this.bitmapData)
//				{
//					var x1:Number = ((_currentFrame+startFrame) % frameWidth)*am.frame_size.x;
//					var y1:Number = int(((_currentFrame+startFrame)/frameWidth))*am.frame_size.y;
//					
//					var rect:Rectangle = new Rectangle(am.delta_pos.x,am.delta_pos.y,am.frame_size.x,am.frame_size.y);
//					this.bitmapData.lock();
//					var p:Point = (new Point(rect.x,rect.y)) as Point;
//					this.bitmapData.copyPixels(bd,(new Rectangle(x1,y1,am.frame_size.x,am.frame_size.y)),p);
//					this.bitmapData.unlock();
////					ResourceManager.instance.releaseResource(p);
//				}
			}

		}
		
		public function gotoAndPlay(frame:uint):void
		{
			_currentFrame = frame;
		}
		
		public function stop():void
		{
			LoopController.instance.removeRenderLoop(lp);
//			this.removeEventListener(Event.RENDER,lp);
		}
		
		public function start():void
		{
			LoopController.instance.addRenderLoop(lp);
//			this.addEventListener(Event.RENDER,lp);
		}
		
		public function destory(deep:Boolean=false):void
		{
			stop();
			if(this.bitmapData)
			{
				//由于要反复使用，此处的bitmapdat是缓存的引用，所以不释放。
//				this.bitmapData.dispose();
				this.bitmapData = null;
			}
			AnimationFinishedCallBack = null;
			this.am = null;
			this.bd = null;
			if(deep)
			{
				delete _initAnimation[Aname];
				for(var keyf:String in _cachedBitmapdatas)
				{
					(_cachedBitmapdatas[keyf] as BitmapData).dispose();
					delete _cachedBitmapdatas[keyf];
				}
			}
		}
	}
}