package com.hurrygames.grabber.logics
{
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;

	public class TowerLogic extends CityLogic
	{
		
		public function TowerLogic(times:Number=1000, callBack:Function=null)
		{
			super(times, callBack);
		}
		
		override protected function callBack():void
		{
			if(levelUping)
			{
				return;
			}
			//人口只减少，不增加.
			var cm:CityModel = ((_entity as CityEntity).Model as CityModel);
			var pm:PlayerModel = ((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel);
			var max:int = cm.level*ConfigManager.populationPreLevel;
			if(cm.current_population > max)
			{
				cm.current_population -= 1;
			}
		}
	}
}