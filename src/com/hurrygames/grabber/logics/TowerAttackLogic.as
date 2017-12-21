package com.hurrygames.grabber.logics
{
	import com.hurrygames.grabber.IRenders.IArmyRender;
	import com.hurrygames.grabber.IRenders.ITowerRender;
	import com.hurrygames.grabber.config.City;
	import com.hurrygames.grabber.entitys.ArmyEntity;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.entitys.PlayerEntity;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ResourceManager;
	import com.hurrygames.grabber.models.ArmyModel;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.renders.TowerRender;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * Project : LandGrabbers
	 * TowerAttackLogic
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class TowerAttackLogic extends TimerCallLogic
	{	
		/**
		 * 累计到几了。根据级别不同，攻击速度的变化。 
		 */		
		private var _attackProgress:Number = 0;
		
		/**
		 *  塔是否处于活跃状态。
		 */		
		public var IsActive:Boolean = false;
		
		public function TowerAttackLogic(times:Number=1000, callBack:Function=null)
		{
			super(times, callBack);
		}
		
		override protected function callBack():void
		{
			var armyes:Vector.<ArmyEntity> = (_entity as CityEntity).OwnerPlayEntity.ownedWarzone.getArmyes();
			if(armyes.length == 0)
			{
				IsActive = false;
				return;
			}
			
			
			var model:CityModel = _entity.Model as CityModel;
			
			_attackProgress += model.level;
			if(_attackProgress >= 5)
			{
				_attackProgress %= 5;
			}else
			{
				return;
			}
			
			var mp:PlayerEntity = (_entity as CityEntity).OwnerPlayEntity;
			
			var range:Number = ConfigManager.TowerBaseRange + (_entity.Model as CityModel).level*ConfigManager.TowerRangePreLevel;
			//塔的攻击范围加成
			range *= (mp.Model as PlayerModel).getTowerRangeGain((_entity.Model as CityModel).type);
			
			IsActive = false;
			
			
//			var t:Number = flash.utils.getTimer();
			
			for each(var army:ArmyEntity in armyes)
			{
				if(army.ownedPlayer != mp)
				{
					var ap:Point = (army.Model as ArmyModel).currentPosition;
					if(ap == null)
					{
						continue;
					}
					
					var tp:Point = (_entity.Model as CityModel).pos;
					///找到塔的下中心点。
					//真实的位置，需要加上一个偏移.
					var len:Point = new Point((ap.x -10 -(tp.x -65)),(ap.y + 20 -(tp.y -41 - (model.level * 10)))) as Point;
					len.x  = ap.x - tp.x;
					len.y = tp.y-ap.y;
					
					if(len.length < range)
					{
						var tr:ITowerRender = _entity.getComponentByName("cityRender") as ITowerRender;
						tr.attackOnePosition(new Point(len.x,len.y+30+(_entity.Model as CityModel).level*10));
						IsActive = true;
						
						var delNum:Number = 1;
						delNum *= (mp.Model as PlayerModel).getTowerAttackGain((_entity.Model as CityModel).type);
						
						(army.Model as ArmyModel).armyPopulation -= Math.round(delNum);
						if((army.Model as ArmyModel).armyPopulation <= 0)
						{
							army.ownedPlayer.ownedWarzone.removeArmy(army);
							
							var ar:IArmyRender = army.getComponentByName("armyRender") as IArmyRender;
							var al:ArmyLogic = army.getComponentByName("armyLogic") as ArmyLogic;
							var am:ArmyModel = army.Model as ArmyModel;
							
							ResourceManager.instance.releaseResource(ar);
							ResourceManager.instance.releaseResource(al);
							ResourceManager.instance.releaseResource(am);
							ResourceManager.instance.releaseResource(army);
							
							army.destory(false);
						}
						break;
					}
//					ResourceManager.instance.releaseResource(len);
				}
			}
			
//			trace("塔攻击寻找消耗的时间为:"+(flash.utils.getTimer()-t)+"MS"+"--队伍长度为"+armyes.length);
		}
	}
} 
