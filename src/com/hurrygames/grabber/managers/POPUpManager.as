package com.hurrygames.grabber.managers
{
	import flash.display.Sprite;
	
	/**
	 * Project : LandGrabbers
	 * POPUpManager
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class POPUpManager
	{
		private var _layer:Sprite;
		private var _mask:Sprite;
		
		private static var _instance:POPUpManager;
		public static function get instance():POPUpManager
		{
			if(_instance == null)
			{
				_instance = new POPUpManager();
			}
			return _instance;
		}
		
		public function POPUpManager()
		{
			if(_instance)
			{
				throw new Error("PopUpManager 是单例类");
			}
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000,0.618);
			_mask.graphics.drawRect(0,0,ConfigManager.GAME_WIDTH,ConfigManager.GAME_HEIGHT);
			_mask.graphics.endFill();
		}
		
		public function initLayer(s:Sprite):void
		{
			_layer = s;
		}
		
		/**
		 * 此方法负责添加上pop。 如果有必要，此处可以加入队列管理。如果有队列的时候，需要管理效果。
		 * @param pop
		 * 
		 */		
		public function showPop(pop:Sprite,haveMask:Boolean=true):void
		{
			if(haveMask)
			{
				_layer.addChild(_mask);
			}else
			{
				if(_mask.parent == _layer)
				{
					_layer.removeChild(_mask);
				}
			}
			_layer.addChild(pop);
		}
		
		public function removePop(pop:Sprite):void
		{
			_layer.removeChild(pop);
			if(_mask.parent == _layer)
			{
				_layer.removeChild(_mask);
			}
		}
	}
} 
