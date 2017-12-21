package com.hurrygames.grabber.managers
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * Project : LandGrabbers
	 * LoopController
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class LoopController
	{
		private static var _instance:LoopController;
		
		public static function get instance():LoopController
		{
			if(_instance)
			{
				
			}else
			{
				_instance = new LoopController();
			}
			return _instance;
		}
		
		private var _logicFunctions:Vector.<FunctionObject> = new Vector.<FunctionObject>();
		
		private var _renderFunctions:Vector.<FunctionObject> = new Vector.<FunctionObject>();
		
		private var _lastTime:Number = 0;
		
		public static var GameSpeedUp:int = 1;
		
		private static var shape:Shape = new Shape();
		public function LoopController()
		{
			shape.addEventListener(Event.ENTER_FRAME,loop);
			_lastTime = flash.utils.getTimer();
		}
		
		private var _stop:Boolean = false;
		public function get stop():Boolean
		{
			return _stop;
		}
		
		public function set stop(s:Boolean):void
		{
			_stop = s;
			if(_stop)
			{
				FightTimerController.instance.stop();
			}else
			{
				FightTimerController.instance.start();
			}
		}
		
		private function loop(e:Event = null):void
		{
			
			if(_stop)	
			{
				_lastTime = flash.utils.getTimer();
				return;
			}
			//此处可以将逻辑和渲染的速度分开，以达到改变逻辑速度而不改变渲染速度的目的。
			//比如加速一倍，则逻辑处理两次，而只是渲染一次。
			var now:Number = flash.utils.getTimer();
			var t:Number = now-_lastTime;
			for(var i:int = 0;i<GameSpeedUp;i++)
			{
				logicLoop(t);
			}
			_lastTime = now;
			now = flash.utils.getTimer();
//			trace("逻辑用的时间为："+(now-_lastTime)+"逻辑函数个数为："+_logicFunctions.length);
			{
				//如果太慢了，则暂时不渲染。
				renderLoop();
			}/*else
			{
//				trace("帧率太低了，进行垃圾回收试试。。");
//				flash.system.System.gc();
			}*/
//			trace("渲染用的时间为-------"+(flash.utils.getTimer()-now)+"-------渲染函数个数为-------"+_renderFunctions.length);
//			
//			LandGrabbers.instance.stage.invalidate();
		}
		
		private function logicLoop(delTime:Number):void
		{
			for each(var lf:FunctionObject in _logicFunctions)
			{
				lf.f.call(null,delTime);
			}
		}
		
		private function renderLoop():void
		{
			for each(var rf:FunctionObject in _renderFunctions)
			{
				if(rf.para)
				{
					rf.f.apply(null,[rf.para]);
				}else
				{
					rf.f.call();
				}
			}
		}
		
		/**
		 * 添加逻辑循环调用函数 
		 * @param logicFunction
		 * @param priority
		 * @return 
		 * 
		 */		
		public function addLogicLoop(logicFunction:Function,priority:int = 5):Boolean
		{
			for each(var o:FunctionObject in _logicFunctions)
			{
				if(o.f === logicFunction)
				{
					return false;
				}
			}
			var fo:FunctionObject = ResourceManager.instance.getResourceByType(FunctionObject) as FunctionObject;
			fo.f = logicFunction;
			fo.priority = priority;
			_logicFunctions.push(fo);
			return true;
		}
		
		/**
		 * 删除逻辑循环调用函数。 
		 * @param logicFunction
		 * 
		 */		
		public function removeLogicLoop(logicFunction:Function):void
		{
			for each(var o:FunctionObject in _logicFunctions)
			{
				if(o.f === logicFunction)
				{
					var fo:FunctionObject = _logicFunctions.splice(_logicFunctions.indexOf(o),1)[0];
					fo.f = null;
					fo.para = null;
					ResourceManager.instance.releaseResource(fo);
				}
			}
		}
		
		/**
		 * 添加渲染回调
		 * @param renderFunction
		 * @param priority
		 * @param para
		 * @return 
		 * 
		 */		
		public function addRenderLoop(renderFunction:Function,priority:int = 0,para:Object = null):Boolean
		{
			for each(var o:FunctionObject in _renderFunctions)
			{
				if(o.f === renderFunction)
				{
					return false;
				}
			}
			var fo:FunctionObject = ResourceManager.instance.getResourceByType(FunctionObject) as FunctionObject;
			fo.f = renderFunction;
			fo.para = para;
			fo.priority = priority;
			_renderFunctions.push(fo);
			return true;
		}
		
		/**
		 * 删除渲染回调。 
		 * @param renderFunction
		 * 
		 */		
		public function removeRenderLoop(renderFunction:Function):Boolean
		{
			for each(var o:FunctionObject in _renderFunctions)
			{
				if(o.f === renderFunction)
				{
					var fo:FunctionObject = _renderFunctions.splice(_renderFunctions.indexOf(o),1)[0];
					fo.f = null;
					fo.para = null;
					ResourceManager.instance.releaseResource(fo);
					return true;
				}
			}
			return false;
		}
	}
} 
