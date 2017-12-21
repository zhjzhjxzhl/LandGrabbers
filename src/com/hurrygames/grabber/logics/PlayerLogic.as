package com.hurrygames.grabber.logics
{
	import com.hurrygames.grabber.IRenders.IArmyRender;
	import com.hurrygames.grabber.config.Path_count_node;
	import com.hurrygames.grabber.core.BaseLogic;
	import com.hurrygames.grabber.entitys.ArmyEntity;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.entitys.PlayerEntity;
//	import com.hurrygames.grabber.gpu.GPUArmyRender;
//	import com.hurrygames.grabber.gpu.GPULayer;
//	import com.hurrygames.grabber.gpu.GPUResourceManager;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ResourceManager;
	import com.hurrygames.grabber.models.ArmyModel;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.models.WarzoneModel;
	import com.hurrygames.grabber.renders.ArmyRender;

	/**
	 * 完成player的基本操作。 
	 * @author Administrator
	 * 
	 */	
	public class PlayerLogic extends BaseLogic
	{
		public function PlayerLogic()
		{
		}
		
		/**
		 * 攻击一次或者向我方城市调兵 ,使用第二个参数里的我方城市。如果第二个参数是null，则使用此player已经选中的城市。
		 * 
		 */		
		public function attackOneCityWithNode(targetCity:CityEntity,useCity:Vector.<CityEntity> = null):void
		{
			if(useCity == null)
			{
				useCity = (_entity as PlayerEntity).selectedCities;
			}
			if(useCity.length == 0)
			{
				return;
			}
			
			var targetModel:CityModel = (targetCity.Model as CityModel);
			//构建路径
//			LandGrabbers.instance.findPathLayer.graphics.clear();
			
			//构建邻接图。
			var allPassableNode:Vector.<Path_count_node> = new Vector.<Path_count_node>();
			for each(var ownedCity:CityEntity in (_entity as PlayerEntity).ownerCities)
			{
				allPassableNode.push(((_entity as PlayerEntity).ownedWarzone.Model as WarzoneModel).path_count_node[(ownedCity.Model as CityModel).count_node_number]);
			}
			
			var targetNode:Path_count_node = LandGrabbers.instance.warField.wz.path_count_node[targetModel.count_node_number];
			
			allPassableNode.push(targetNode);
			
			LandGrabbers.instance.warField.map.buildPath(targetModel.count_node_number,allPassableNode);
			
			while(allPassableNode.length > 0)
			{
				allPassableNode.pop();
			}
			allPassableNode = null;
			
			
//			var total:Number = 0;
			for each(var city:CityEntity in useCity)
			{
				var model:CityModel = city.Model as CityModel;
				//将路径绘制出来。
//				LandGrabbers.instance.drawPathForNode(LandGrabbers.instance.wz.path_count_node[model.count_node_number],targetNode,ConfigManager.PlayerToColor[(_entity.Model as PlayerModel).PlayerId]);
				
				var half:int = int(model.current_population/2);
				model.current_population -= half;
//				total += half*(model.strong_armies?2:1);
				
				///增加一支军队
				var army:ArmyEntity = ResourceManager.instance.getResourceByType(ArmyEntity) as ArmyEntity;
				army.fromCity = city;
				army.targetCity = targetCity;
				army.ownedPlayer = _entity as PlayerEntity;
				army.addComponent(ResourceManager.instance.getResourceByType(ArmyModel) as ArmyModel,null);
				(army.Model as ArmyModel).armyPopulation = half;
				var path:Vector.<Path_count_node> = new Vector.<Path_count_node>();
				var start:Path_count_node = LandGrabbers.instance.warField.wz.path_count_node[model.count_node_number];
				var hasNoPassedCity:Boolean = false;
				while(start)
				{
					if(start.city)
					{
						if(city.OwnerPlayEntity != _entity)
						{
							hasNoPassedCity = true;
							break;
						}
					}
					path.push(start);
					start = start.preNode;
				}
				if(path.length<2)
				{
					continue;
				}
				if(hasNoPassedCity)
				{
					continue;
				}
				(army.Model as ArmyModel).path = path;
				
				army.addComponent(ResourceManager.instance.getResourceByType(ArmyLogic) as ArmyLogic,"armyLogic");
				var ar:IArmyRender;
				if(CONFIG::GPU)
				{
					ar = ResourceManager.instance.getResourceByType(GPUArmyRender) as GPUArmyRender;
					GPULayer.instance.armyLayer.addChild((ar as GPUArmyRender).ArmySprite);
				}else
				{
					ar = ResourceManager.instance.getResourceByType(ArmyRender) as ArmyRender;
					LandGrabbers.instance.warField.armyLayer.addChild((ar as ArmyRender).ArmySprite);
				}
				army.addComponent(ar,"armyRender");
				
				(_entity as PlayerEntity).ownedWarzone.addArmy(army);
			}
			
			(_entity as PlayerEntity).clearSelected();
		}
		
		/**
		 * 升级某个建筑 
		 * 
		 */		
		public function LevelUpOneCity(cityEntity:CityEntity):void
		{
			var cl:CityLogic = cityEntity.getComponentByName("cityLogic") as CityLogic;
			if(cl)
			{
				if(LandGrabbers.instance.warField.wz.max_upgrade_level >= (cityEntity.Model as CityModel).level)
				{
					return;
				}
				cl.levelUp();
			}
		}
	}
}