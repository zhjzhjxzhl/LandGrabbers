package com.hurrygames.grabber.models
{
	import com.hurrygames.grabber.config.Player;
	import com.hurrygames.grabber.core.IEntity;
	import com.hurrygames.grabber.core.IModel;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.itemSys.EquipmentDes;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ItemDescriptionManager;
	import com.hurrygames.grabber.vo.equipment.EquipmentVO;
	
	
	/**
	 * Project : LandGrabbers
	 * PlayerModel
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class PlayerModel extends Player implements IModel
	{
		
		public var PlayerId:int = 0;
		
		/**
		 * 此玩家技能数值的索引。总共有五种建筑，所以有五行。总共有8种技能效果，所以有8列。
		 * 即：对五种建筑，每种有八个技能影响。 
		 */		
		public var skills:Array = 	[
										[],//此行填空，因为从1开始。
										[1,1,1,1,1,1,1,1],
										[1,1,1,1,1,1,1,1],
										[1,1,1,1,1,1,1,1],
										[1,1,1,1,1,1,1,1],
										[1,1,1,1,1,1,1,1]
									];
		
		private var _buildingPeopleMax:int = 0;
		/**
		 * 建筑容纳兵的上限的增加数。 
		 */
		public function get buildingPeopleMax():int
		{
			return _buildingPeopleMax;
		}
		
		/**
		 * 将装备的属性加入到附加属性里。 
		 * @param equipments
		 * 
		 */
		public function setEquipments(equipments:Vector.<EquipmentVO>):void
		{
			for each(var equip:EquipmentVO in equipments)
			{
				var equipDes:EquipmentDes = ItemDescriptionManager.instance.equipmentDesDictionary[equip.equipmentType] as EquipmentDes;
				var i:int  =1;
				if(equipDes.property_type == "buildingLimit")
				{
					//人口上限
					_buildingPeopleMax += equipDes.property_value;
				}else if(equipDes.property_type == "forcesDamage")
				{
					//攻击加成
					i = 1;
					for(;i<6;i++)
					{
						skills[i][0] *= (1+equipDes.property_value);
					}
				}else if(equipDes.property_type == "forcesMovementSpeed")
				{
					//移动速度加成
					i = 1;
					for(;i<6;i++)
					{
						skills[i][1] *= (1+equipDes.property_value);
					}
				}else if(equipDes.property_type == "productiongForces")
				{
					//城市人口增长速度
					i = 1;
					for(;i<6;i++)
					{
						skills[i][2] *= (1+equipDes.property_value);
					}
				}else if(equipDes.property_type == "buildingDefense")
				{
					//城市防御力加成
					i = 1;
					for(;i<6;i++)
					{
						skills[i][3] *= (1+equipDes.property_value);
					}
				}
			}
		}
		
		public function PlayerModel(string:String)
		{
			super(string);
		}
		
		public function set Entity(entity:IEntity):void
		{
		}
		
		public function init(para:*):void
		{
			
		}
		
		public function destory(deep:Boolean = true):void
		{
			lineString = null;
		}
		
		
		private var _citys:Array = [];
		
		/**
		 * 获取此玩家的所有的城市 
		 * @return 
		 * 
		 */		
		public function get citys():Array
		{
			return _citys;
		}
		
		/**
		 * 给玩家添加一个城市 
		 * @param city
		 * 
		 */		
		public function addCity(city:CityEntity):void
		{
			if(_citys.indexOf(city) == -1)
			{
				_citys.push(city);
			}
		}
		
		/**
		 * 删除一个城市 
		 * @param city
		 * 
		 */		
		public function removeOneCity(city:CityEntity):void
		{
			var index:int = _citys.indexOf(city);
			if(index != -1)
			{
				_citys.splice(index,1);
			}
		}
		
		public function getOneCityByNode(nodeId:int):CityEntity
		{
			for each(var city:CityEntity in _citys)
			{
				if((city.Model as CityModel).count_node_number == nodeId)
				{
					return city;
				}
			}
			return null;
		}
		
		
		/**
		 * 获取玩家部队的增益。 技能类型1
		 * @param armyType 1是普通军队，2是骑兵，3是强壮的军队。 
		 * @return 返回值是个倍数。正确是数值是1.1,1.3 等。。
		 * 
		 */		
		public function getArmyAttackGain(armyType:int):Number
		{
			return skills[armyType][0];
		}
		/**
		 * 获取玩家速度的增益 .技能类型2
		 * @param armyType 1是普通军队，2是骑兵，3是强壮的军队。 
		 * @return 返回值是个倍数。正确是数值是1.1,1.3 等。。大于一的一个数
		 * 
		 */		
		public function getArmySpeedGain(armyType:int):Number
		{
			return skills[armyType][1];
		}
		
		/**
		 * 获取城市人口增长速度的加成。 技能类型3
		 * @param cityType 1是普通城市，2是马厩，3是铁匠铺,5是城堡
		 * @return 
		 * 
		 */		
		public function getCityPeopleAddSpeedGain(cityType:int):Number
		{
			return skills[cityType][2];
		}
		
		/**
		 * 获取城市防御力加成 技能类型4
		 * @param cityType 1是普通城市，2是马厩，3是铁匠铺，4是防御塔,5是城堡
		 * @return 
		 * 
		 */		
		public function getCityDefenceGain(cityType:int):Number
		{
			return skills[cityType][3];
		}
		
		/**
		 * 获取城市升级时消耗的人口的加成 技能类型5
		 * @param cityType	1是普通城市，2是马厩，3是铁匠铺，4是防御塔,5是城堡
		 * @return 此处返回的值是一个小于1的小数，表示消耗是以前的百分比。
		 * 
		 */		
		public function getCityLevelUpPeopleDelGain(cityType:int):Number
		{
			return skills[cityType][4];
		}
		
		/**
		 *  获取城市升级时间的加成。技能类型6
		 * @param cityType 1普通城市，2马厩，3铁匠铺，4是防御塔,5是城堡
		 * @return 此处返回的是一个小于1的小数，表示消耗的百分比。
		 * 
		 */		
		public function getCityLevelUpTimeGain(cityType:int):Number
		{
			return skills[cityType][5];
		}
		
		/**
		 * 获取防御塔的攻击加成。 技能类型7
		 * @param cityType 4表示防御塔
		 * @return  返回一个大于1的小数。表示加成比例1.2等
		 * 
		 */		
		public function getTowerAttackGain(cityType:int):Number
		{
			return skills[cityType][6];
		}
		
		/**
		 * 获取防御塔的范围加成 技能类型8
		 * @param cityType 4表示防御塔
		 * @return  返回一个大于1的小数。表示比例加成。
		 * 
		 */		
		public function getTowerRangeGain(cityType:int):Number
		{
			return skills[cityType][7];
		}
	}
}
