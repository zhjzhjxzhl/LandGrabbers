package com.hurrygames.grabber.managers
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * Project : LandGrabbers
	 * ResourceLoadManager
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ResourceLoadManager
	{
		private static var _loader:BulkLoader = new BulkLoader("iconLoader",5);
		private static var _start:Boolean = false;
		
		public function ResourceLoadManager()
		{
			_loader.addEventListener(BulkProgressEvent.COMPLETE,complete);
		}
		
		protected function complete(event:Event):void
		{
			trace("complete");
		}
		
		public static function showRes(parent:DisplayObjectContainer,url:String,x:Number = 0,y:Number = 0,center:Boolean = false):void
		{
			var loadItem:LoadingItem = _loader.add(url);
			loadItem.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				var dis:DisplayObject = loadItem.content as DisplayObject;
				dis.x = x;
				dis.y = y;
				if(center)
				{
					dis.x = (parent.width-dis.width)/2;
					dis.y = (parent.height-dis.height)/2;
				}
				parent.addChild(dis);
			});
			if(!_start)
			{
				_start = true;
				_loader.start(8);
			}
		}
	}
} 
