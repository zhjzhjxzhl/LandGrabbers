package com.hurrygames.grabber.managers
{
	import com.hurrygames.grabber.utils.PathPoint;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Project : LandGrabbers
	 * ResourceManager 管理所有的new的问题。反复的new会导致给gc大量的压力
	 * 最终导致游戏被拖慢。所以采用此种方式，所有的new操作都在此处进行。
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ResourceManager
	{
		private static var _instance:ResourceManager;
		public static function get instance():ResourceManager
		{
			return (_instance == null)?(_instance = new ResourceManager()):_instance;
		}
		
		public function ResourceManager()
		{
		}
		
		/**
		 * 所有的种类对应的字典。 
		 */		
		private var _dictionary:Dictionary = new Dictionary();
		
		/**
		 * 根据给定的类型获得指定的类的实例.
		 * 最多可以管理有四个参数的构造函数。
		 * @param type
		 * @return 
		 * 
		 */		
		public function getResourceByType(type:Class,...rest):Object
		{
			var oo:Object;
			if(_dictionary[type] != null)
			{
				oo = _dictionary[type].pop();
			}
			if(oo == null)
			{
				switch(rest.length)
				{
					case 0:
						oo = new type();
						break;
					case 1:
						oo = new type(rest[0]);
						break;
					case 2:
						oo = new type(rest[0],rest[1]);
						break;
					case 3:
						oo = new type(rest[0],rest[1],rest[2]);
						break;
					case 4:
						oo = new type(rest[0],rest[1],rest[2],rest[3]);
						break;
					default:
						throw (new Error("此类只能管理有最多四个参数的构造函数的类"));
						break;
				}
			}else
			{
				if(oo is Point)
				{
					oo.x = rest[0];
					oo.y = rest[1];
				}
				if(oo is Rectangle)
				{
					oo.x = rest[0];
					oo.y = rest[1];
					oo.width = rest[2];
					oo.height = rest[3];
				}
			}
			return oo;
		}
		
		private var ppNumber:int = 0;
		
		public function releaseResource(resource:Object):void
		{
			if(resource == null)
			{
				return;
			}
			var type:Class = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName(resource)) as Class;
			if(_dictionary[type] == null)
			{
				_dictionary[type] = [];
			}
			_dictionary[type].push(resource);
			if(resource is Point)
			{
				resource.x = resource.y = 0;
			}
			if(resource is Rectangle)
			{
				resource.x = resource.y = resource.width = resource.height = 0;
			}
		}
	}
} 
