package com.hurrygames.grabber.config
{
	import flash.geom.Point;
	
	/**
	 * Project : LandGrabbers
	 * City
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class City extends BaseModel
	{
		public var name:String;
		
		/**
		 * 位置 
		 */		
		private var _pos:Point;
		public function get pos():Point
		{
			return _pos;
			if(_pos == null)
			{
				return null;
			}
			var p1:Point = new Point(_pos.x/1.28,_pos.y/1.28);
			return p1;
		}
		public function set pos(p:Point):void
		{
			_pos = p;
		}
		
		/**
		 * 起始人口数量 
		 */		
		public var start_population:int;
		
		/**
		 * 起始级别 
		 */		
		public var level:int;
		
		/**
		 * 拥有者 
		 */		
		public var owner:int;
		
		/**
		 * 塔的范围 
		 */		
		public var tower_range:Point;
		
		/**
		 * 所处的层次 
		 */		
		public var layer:int;
		
		/**
		 * 连接的路径节点的编号。即连接着几号路径节点。
		 *  
		 */		
		public var count_node_number:int;
		
		/**
		 * 更高的防御
		 */		
		public var fortification:Boolean;
		
		/**
		 * 更强的攻击力 
		 */		
		public var strong_armies:Boolean;
		
		/**
		 * 更快的速度 
		 */		
		public var fast_armies:Boolean;
		
		/**
		 * 是否是塔。 
		 */		
		public var tower:Boolean;
		
		/**
		 * 城市的类型 1.普通城市，2.骑兵城市，3.武器铺，4.塔 ,5是城堡
		 */		
		public var type:int;
		
		public function City(string:String)
		{
			super(string);
			if(tower)
			{
				type = 4;
			}else if(fast_armies)
			{
				type = 2;
			}else if(strong_armies)
			{
				type = 3;
			}else if(fortification)
			{
				type = 5;
			}else
			{
				type = 1;
			}
		}
		
		/**
		 * 0是塔楼，1是马厩，2是城堡，3是普通城市 
		 * @return 
		 * 
		 */
		public function getAttackType():int
		{
			switch(type)
			{
				case 4:
					return 0;
					break;
				case 2:
					return 1;
					break;
				case 5:
					return 2;
					break;
				case 1:
					return 3;
					break;
			}
			return 0;
		}
	}
} 
