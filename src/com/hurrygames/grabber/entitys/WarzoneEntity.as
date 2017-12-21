package com.hurrygames.grabber.entitys
{
	import com.hurrygames.grabber.core.BaseEntity;
	import com.hurrygames.grabber.models.PlayerModel;
	
	
	/**
	 * Project : LandGrabbers
	 * WarzoneEntity
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class WarzoneEntity extends BaseEntity
	{
		/**
		 *所有玩家 
		 */		
		public var players:Vector.<PlayerEntity> = new Vector.<PlayerEntity>();
		
		public var cities:Vector.<CityEntity> = new Vector.<CityEntity>();
		
		private var armyes:Vector.<ArmyEntity> = new Vector.<ArmyEntity>();
		
		public function WarzoneEntity()
		{
			super();
		}
		
		public function getPlayerById(playerId:int):PlayerEntity
		{
			for each(var player:PlayerEntity in players)
			{
				if((player.Model as PlayerModel).PlayerId == playerId)
				{
					return player;
				}
			}
			return null;
		}
		
		/**
		 * 添加一直军队 
		 * @param ae
		 * 
		 */		
		public function addArmy(ae:ArmyEntity):void
		{
			if(armyes.indexOf(ae) == -1)
			{
				armyes.push(ae);
				ae.ownedPlayer.currentArmyNumber++;
			}
		}
		
		/**
		 * 减去一直军队。 
		 * @param ae
		 * 
		 */		
		public function removeArmy(ae:ArmyEntity):void
		{
			var index:int = armyes.indexOf(ae);
			if(index != -1)
			{
				armyes.splice(index,1);
				ae.ownedPlayer.currentArmyNumber--;
			}
		}
		
		public function getArmyes():Vector.<ArmyEntity>
		{
			return armyes;
		}
		
		override public function destory(deep:Boolean = true):void
		{
			super.destory(deep);
			while(players.length>0)
			{
				var pe:PlayerEntity = players.pop();
				if(deep)
				{
					pe.destory(deep);
				}
			}
			players = null;
			while(cities.length>0)
			{
				var ce:CityEntity = cities.pop();
				if(deep)
				{
					ce.destory(deep);
				}
			}
			cities = null;
			while(armyes.length>0)
			{
				var ae:ArmyEntity = armyes.pop();
				if(deep)
				{
					ae.destory(deep);
				}
			}
			armyes = null;
		}
	}
} 
