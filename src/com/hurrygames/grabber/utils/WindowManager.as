package com.hurrygames.grabber.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	
	
	/**
	 * 弹出窗管理类
	 * 
	 * @author 任冬 rendong@corp.the9.com
	 * $Id: WindowManager.as 643 2011-03-05 07:12:18Z hanbing $
	 * @version 1.0
	 */
	public class WindowManager
	{
		/**
		 * 设置默认的弹出窗口父容器
		 */		
		public static var defaultParent:DisplayObjectContainer;
		/**
		 *  设置默认的弹出窗口父容器的宽度
		 */		
		public static var defaultWindowWidth:Number;
		/**
		 * 设置默认的弹出窗口父容器的宽度 
		 */		
		public static var defaultWindowHeight:Number;
		
		/**
		 * 记录遮罩和显示对象的关系 
		 */		
		private static var maskMap:Dictionary = new Dictionary(true);
		
		/**
		 * 记录弹出窗口参数 
		 */		
		private static var popMap:Dictionary = new Dictionary(true);
		
		/**
		 * 记录禁用的对象的参数 
		 */		
		private static var disableMap:Dictionary = new Dictionary(true);
		
		/**
		 * 添加遮罩，一个透明的层 
		 * @param container	遮罩的容器
		 * @param width		遮罩的宽度	如果为0，则取容器的宽度
		 * @param height	遮罩的高度	如果为0，则取容器的高度
		 * @param _color	遮罩的颜色值，一般不需要修改
		 * @param _alpha	遮罩的透明度，一般不需要修改
		 * 
		 */
		public static function addMask( container:DisplayObjectContainer, width:Number=0, height:Number=0, _color:uint=0x000, _alpha:Number=0.1):Sprite
		{
			var mask:Sprite;
			
			if (width == 0)
				width = container.width;
			if (height == 0)
				height = container.height;
			
			// 背景颜色 透明层
			mask = new Sprite();
			mask.graphics.beginFill(0x000, _alpha);
			mask.graphics.drawRect(0, 0, width,height);
			mask.graphics.endFill();
			mask.cacheAsBitmap = true;
			
			var arr:Vector.<Sprite> = maskMap[container];
			if (arr == null)
			{
				arr = new Vector.<Sprite>();
				maskMap[container] = arr;
			}
			arr.push(mask);
			container.addChild(mask);
			
			return mask;
		}
		
		/**
		 * 移除最后添加在容器上的遮罩，从上往下挨着移除 
		 * @param container	移除的容器
		 * @param removeAll	是否全部移除
		 * 
		 */		
		public static function removeLastMask(container:DisplayObjectContainer, removeAll:Boolean = false):void
		{
			var arr:Vector.<Sprite> = maskMap[container];
			if (arr == null || arr.length == 0)
				return;
			
			var mask:Sprite;
			while(arr.length != 0)
			{
				mask = arr.pop();
				if (mask != null && container.contains(mask))
					container.removeChild(mask);
				if (!removeAll)
					break;
			}

		}
		
		/**
		 * 通过遮罩对象移除遮罩 
		 * @param mask
		 * 
		 */		
		public static function removeMaskByObj(mask:Sprite):void
		{
			var container:DisplayObjectContainer = mask.parent;
			
			var arr:Vector.<Sprite> = maskMap[container];
			if (arr == null || arr.length == 0)
				return;
			var index:int = arr.indexOf(mask);
			if (index != -1)
				arr.splice(index, 1);
			
			if (container.contains(mask))
				container.removeChild(mask);
		}
		
		
		/**
		 * 前置显示对象
		 * 
		 * @param	mc	前置的mc
		 * @param	stopParent	前置停止mc
		 */
		public static function setFront(mc:DisplayObject, stopParent:DisplayObject = null):void
		{
			while (mc != stopParent && mc.parent)
			{
				mc.parent.setChildIndex(mc, mc.parent.numChildren -1);
				
				mc = mc.parent;
			}
		}
		
		/**
		 * 禁用可视化对象 
		 * @param mc
		 * @param isDisable
		 * 
		 */		
		public static function disableDisplayObject(mc:InteractiveObject, isDisable:Boolean = true):void
		{
			var param:Object;
			
			if (isDisable)
			{
				if (disableMap[mc])
					return;
				
				var greyfilter:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
				
				param = {};
				param['greyfilter'] = greyfilter;
				param['mouseEnabled'] = mc.mouseEnabled;
				param['filter'] = mc.filters;
				disableMap[mc] = param;
				
				mc.filters = [greyfilter];
				
				if (isDisable){
					mc.mouseEnabled = false;
					if (mc.hasOwnProperty('mouseChildren')){
						param['mouseChildren'] = mc['mouseChildren'];
						mc['mouseChildren'] = false;
					}
				}
			}else {
				param = disableMap[mc];
				if ( param == null)
					return;
				
				mc.filters = param['filter'];
				
				mc.mouseEnabled = param['mouseEnabled'];
				if (mc.hasOwnProperty('mouseChildren'))
					mc['mouseChildren'] = param['mouseChildren'];
				
				delete disableMap[mc];
			}
		}

	}
}