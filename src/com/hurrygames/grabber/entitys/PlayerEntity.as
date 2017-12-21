package com.hurrygames.grabber.entitys
{
	import com.hurrygames.grabber.IRenders.ICityRender;
	import com.hurrygames.grabber.config.Path_count_node;
	import com.hurrygames.grabber.core.BaseEntity;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.WarzoneModel;
	
	import flash.utils.getTimer;
	
	
	/**
	 * Project : LandGrabbers
	 * PlayerEntity
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class PlayerEntity extends BaseEntity
	{
		/**
		 * 拥有的城市 
		 */		
		public var ownerCities:Vector.<CityEntity> = new Vector.<CityEntity>();
		
		/**
		 * 选择用来进攻的城市 
		 */		
		public var selectedCities:Vector.<CityEntity> = new Vector.<CityEntity>();
		
		private var _adjoinCities:Vector.<Path_count_node> = new Vector.<Path_count_node>();
		
		private var _cityChange:Boolean = true;
		
		public var ownedWarzone:WarzoneEntity;
		
		/**
		 * 当前此玩家出动的部队数。 此数字有个限制。一方面是为性能考虑，一方面也为了降低ai的攻击强度。
		 * 特别是在地图变大的时候，地图上会有过多军队。
		 */		
		public var currentArmyNumber:int = 0;
		
		public function PlayerEntity()
		{
			super();
		}
		
		/**
		 * 添加一个城市 
		 * @param cityEntity
		 * 
		 */		
		public function addOneCity(cityEntity:CityEntity):void
		{
			if(ownerCities.indexOf(cityEntity) == -1)
			{
				ownerCities.push(cityEntity);
				_cityChange = true;
			}
		}
		
		/**
		 * 移除一个城市. 
		 * @param cityEntity
		 * 
		 */		
		public function removeOneCity(cityEntity:CityEntity):void
		{
			var index:int = ownerCities.indexOf(cityEntity);
			if(index != -1)
			{
				ownerCities.splice(index,1);
				_cityChange = true;
			}
		}
		
		/**
		 * 添加一个选中的城市 
		 * @param cityEntity
		 * 
		 */		
		public function addOneSelectedCity(cityEntity:CityEntity):void
		{
			if(selectedCities.indexOf(cityEntity) == -1)
			{
				selectedCities.push(cityEntity);
			}
		}
		
		public function removeOneSelectedCity(cityEntity:CityEntity):void
		{
			if(selectedCities.indexOf(cityEntity) != -1)
			{
				selectedCities.splice(selectedCities.indexOf(cityEntity),1);
			}
		}
		
		/**
		 * 清除所有的选中城市。 
		 * 
		 */		
		public function clearSelected():void
		{
			for each(var citye:CityEntity in selectedCities)
			{
				(citye.getComponentByName("cityRender") as ICityRender).removeSelected();
			}
			while(selectedCities.length>0)
			{
				selectedCities.pop();
			}
		}
		
		/**
		 * 获得相邻的城市
		 * @return 
		 * 
		 */		
		public function getAdjoinCities():Vector.<Path_count_node>
		{
			if(!_cityChange)
			{
			}else
			{
				buildAdjoin();
				_cityChange = false;
			}
			return _adjoinCities;
		}
		
		/**
		 * 构建相邻城市列表。 
		 * 
		 */		
		private function buildAdjoin():void
		{
			var t:Number = flash.utils.getTimer();
			//置空相邻数组.
			while(_adjoinCities.length > 0)
			{
				_adjoinCities.pop();
			}
			//我的城市对应的节点。
			var myNodes:Vector.<Path_count_node> = new Vector.<Path_count_node>();
			for each(var city:CityEntity in ownerCities)
			{
				myNodes.push((ownedWarzone.Model as WarzoneModel).path_count_node[(city.Model as CityModel).count_node_number]);
			}
			//将所有节点初始化。
			for each(var pn:Path_count_node in (ownedWarzone.Model as WarzoneModel).path_count_node)
			{
				pn.isPassed = false;
				pn.isMine = false;
			}
			
			//等待队列，此队列中的节点是需要遍历的节点。
			var waitQuene:Vector.<Path_count_node> = myNodes;
			for each(var mnpcn:Path_count_node in myNodes)
			{
				mnpcn.isMine = true;
				mnpcn.selectDistance = 0;
			}
			myNodes = null;
			
			while(waitQuene.length > 0)
			{
				var pcn:Path_count_node = waitQuene.shift();
				pcn.isPassed = true;
				//如果大于15，则表示是建筑点。如果此建筑点目前不是自己的，则不从此点继续广度搜索。否则的话，将此点放入毗邻数组。
				if(pcn.radius > 15)
				{
//					if(myNodes.indexOf(pcn) == -1)
					if(!pcn.isMine)
					{
						_adjoinCities.push(pcn);
						continue;
					}
				}
				for each(var node:int in pcn.edge)
				{
					var adjoinP:Path_count_node = (ownedWarzone.Model as WarzoneModel).path_count_node[node];
					if(adjoinP.isPassed)
					{
						if((pcn.selectDistance+1) < adjoinP.selectDistance)
						{
							adjoinP.selectDistance = (pcn.selectDistance+1);
						}
						continue;
					}
					if(waitQuene.indexOf(adjoinP) != -1)
					{
						if((pcn.selectDistance+1) < adjoinP.selectDistance)
						{
							adjoinP.selectDistance = (pcn.selectDistance+1);
						}
						continue;
					}
					adjoinP.selectDistance = pcn.selectDistance+1;
					waitQuene.push(adjoinP);
				}
			}
			
//			trace("构建邻接图花费的时间为："+(flash.utils.getTimer()-t)+"MS");
			
		}
		
		override public function destory(deep:Boolean = true):void
		{
			super.destory(deep);
			while(ownerCities.length>0)
			{
				ownerCities.pop();
			}
			ownerCities = null;
			
			while(selectedCities.length>0)
			{
				selectedCities.pop();
			}
			selectedCities = null;
		}
		
	}
} 
