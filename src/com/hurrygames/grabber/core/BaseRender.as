package com.hurrygames.grabber.core
{
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * Project : LandGrabbers
	 * BaseRender
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class BaseRender extends BaseComponent implements IRender
	{
		public function BaseRender()
		{
		}
		
		public function render():void
		{
		}
		
//		private function rr(e:Event):void
//		{
//			render();
//		}
//		
//		override public function init(para:*):void
//		{
//			LandGrabbers.instance.addEventListener(Event.RENDER,rr);
//		}
//		
//		override public function destory(deep:Boolean=true):void
//		{
//			LandGrabbers.instance.removeEventListener(Event.RENDER,rr);
//		}
	}
} 
