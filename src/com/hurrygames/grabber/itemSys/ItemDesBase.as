package com.hurrygames.grabber.itemSys
{
	
	/**
	 * Project : LandGrabbers
	 * ItemDesBase
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ItemDesBase
	{
		public var id:int;
		
		/**
		 *构造函数，接收一个键值对的object，为其赋值，如果不传，可以之后再传 
		 * @param object
		 * 
		 */
		public function ItemDesBase(object:Object=null)
		{
			if(object != null)
			{
				installDataObject(object);
			}
		}
		private function installDataObject(object:Object):void
		{
			for each(var s:String in object)
			{
				if(this.hasOwnProperty(s))
				{
					this[s] = object[s];
				}
			}
		}
		
		public function installFromXml(xml:XML):void
		{
			for each(var line:XML in xml.column)
			{
				var property:String = line.@name;
				if(this.hasOwnProperty(property))
				{
					this[property] = line.toString();
				}
			}
		}
	}
} 
