package com.hurrygames.grabber.logics
{
	import com.hurrygames.grabber.config.Path_count_node;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.entitys.PlayerEntity;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.models.WarzoneModel;

	/**
	 * player的ai逻辑控制器 
	 * @author Administrator
	 * 
	 */	
	public class PlayerAILogic extends TimerCallLogic
	{
		/**
		 *距离转化系数
		 */
		private static const DISTANCE_TRANS:Number = 2;
		
		/**
		 *城市类型转化系数 
		 */
		private static const CITY_TYPE_TRANS:Number = 10;
		
		/**
		 *攻击目标选择的时候，城市的所有者系数转化比例 
		 */
		private static const CITY_OWNER_TRANS:Number = 15;
		
		/**
		 * 根据city 和 citynode，计算city的值。用作以后比较用。 
		 * @param cm
		 * @param cityNode
		 * 
		 */
		private function computeCitySelecteValue(cm:CityModel,cityNode:Path_count_node):void
		{
			var plm:PlayerModel = (_entity.Model as PlayerModel);
			var result:Number = 0;
			//计算人口的影响
			result += cm.current_population*plm.ai_build_people_prcent;
			//计算距离的影响
			result += DISTANCE_TRANS*cityNode.selectDistance*plm.ai_build_distance_prcent;
			//计算类型的影响
			result += (plm.ai_build_selecte.indexOf(cm.getAttackType())+1)*CITY_TYPE_TRANS*plm.ai_build_select_prcent;
			//计算所属玩家的影响
			var ownerT:int = (cm.owner>2)?2:cm.owner;
			result += (plm.ai_build_owner_select.indexOf(ownerT)+1)*CITY_OWNER_TRANS*plm.ai_build_player_prcent;
			
			cm.selectedNumber = result;
		}
		
		public function PlayerAILogic(times:Number=1000, callBack:Function=null)
		{
			super(times, callBack);
		}
		
		/**
		 * 在这个方法里，实现一些aI的逻辑。比如升级建筑，发起攻击。
		 * ai的逻辑还要决定是根据升级那些建筑。使用那些建筑的军队发起攻击。
		 * 
		 */		
		override protected function callBack():void
		{
			super.callBack();
			var playerE:PlayerEntity = _entity as PlayerEntity;
			var playerModel:PlayerModel = (_entity.Model as PlayerModel);
			if((playerE.currentArmyNumber<ConfigManager.AIOwnedMaxArmyNumber)&&(Math.random() < playerModel.ai_attack_upgread))
			{
//				trace("目前玩家 "+(playerE.Model as PlayerModel).PlayerId+" 拥有的军队数量是："+playerE.currentArmyNumber);
				//发起攻击
				var hasTower:Boolean = false;
				var tower:CityEntity;
				for each(var city:CityEntity in playerE.ownerCities)
				{
					if((city.Model as CityModel).current_population > (city.Model as CityModel).level*ConfigManager.populationPreLevel*playerModel.ai_panic_attack_treshold)
					{
						if(playerE.selectedCities.length < (playerE.Model as PlayerModel).ai_max_armies_per_attack)
						{
							if((city.Model as CityModel).tower)
							{
								//如果是塔，则不管在什么情况下，立即升级.
								if((city.Model as CityModel).current_population > (city.Model as CityModel).level*ConfigManager.populationPreLevel*playerModel.ai_upgrade_treshold)
								{
									(city.getComponentByName("cityLogic") as CityLogic).levelUp();
								}
								
								//不选择塔里的军队去攻击。
								if((city.Model as CityModel).level < (playerE.ownedWarzone.Model as WarzoneModel).max_upgrade_level || ((city.Model as CityModel).current_population<(city.Model as CityModel).level*ConfigManager.populationPreLevel))
								{
									hasTower = true;
									if(tower == null)
									{
										tower = city;
									}else
									{
										//随机往哪几个塔调兵。更随机一点。
										(Math.random() > 0.5)&&(tower = city);
									}
								}
								continue;
							}
							playerE.addOneSelectedCity(city);
						}else
						{
							break;
						}
					}
				}
				
				
				var targetCity:CityEntity;
				
				if(hasTower && (Math.random() < 0.3))
				{
					//攻击的过程中，有0.3的概率是给自己的塔补充兵力
					targetCity = tower;
				}else
				{
					
					for each(var node:Path_count_node in playerE.getAdjoinCities())
					{
						//计算值，来进行选择。
						computeCitySelecteValue((node.city.Model as CityModel),node);
						
						if(targetCity != null)
						{
							if((targetCity.Model as CityModel).selectedNumber >  (node.city.Model as CityModel).selectedNumber)
							{
								targetCity = node.city;
							}
						}else
						{
							targetCity = node.city;
						}
					}
				}
				if(targetCity != null)
				{
					(playerE.getComponentByName("playerLogic") as PlayerLogic).attackOneCityWithNode(targetCity);
				}
			}else
			{
				//升级
				for each(var city1:CityEntity in playerE.ownerCities)
				{
					if((city1.Model as CityModel).current_population > (city1.Model as CityModel).level*ConfigManager.populationPreLevel*playerModel.ai_upgrade_treshold)
					{
						(city1.getComponentByName("cityLogic") as CityLogic).levelUp();
					}
				}
			}
		}
	}
}