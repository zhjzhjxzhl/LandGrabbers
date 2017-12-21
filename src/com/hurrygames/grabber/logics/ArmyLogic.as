package com.hurrygames.grabber.logics
{
	import com.hurrygames.grabber.IRenders.IArmyRender;
	import com.hurrygames.grabber.IRenders.ICityRender;
	import com.hurrygames.grabber.config.Path_count_node;
	import com.hurrygames.grabber.entitys.ArmyEntity;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ResourceManager;
	import com.hurrygames.grabber.models.ArmyModel;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.renders.ArmyRender;
	import com.hurrygames.grabber.utils.PathPoint;
	
	import flash.geom.Point;

	public class ArmyLogic extends TimerCallLogic
	{
		/**
		 * 普通士兵离中轴线的距离。 
		 */		
		public static const DISTANCE:Number = 8;
		
		/**
		 * 每隔几个移动步伐，添加一个士兵。 
		 */		
		public static const STEPFORARMY:Number = 4;
		
		/**
		 * 路径的记录 ，用于非拿旗士兵。
		 */		
		public var pathes:Vector.<PathPoint> = new Vector.<PathPoint>();
		
		
		private var currentTarget:Path_count_node;
		
		private var currentIndex:int = 0;
		
		/**
		 * 是否正在进攻 
		 */		
		public var attacking:Boolean = false;
		
		/**
		 * 举旗的人是否已经到达 
		 */		
		private var flagReach:Boolean = false;
		
		/**
		 * 目标城市。 
		 */		
		private var _targetNode:Path_count_node;
		
		public var lastPathVector:Point;
		
		public function ArmyLogic(times:Number=1000, callBack:Function=null)
		{
			super(times, callBack);
		}
		
		override public function onTick(delTime:Number):void
		{
			var model:ArmyModel = _entity.Model as ArmyModel;
			
			if(currentTarget == null)
			{
				//尚未开始移动。初始化位置。
				currentTarget = model.path[0];
				model.currentPosition = new Point(currentTarget.point.x,currentTarget.point.y) as Point;
				currentIndex = 0;
				changeSpeed();
				currentTarget = model.path[1];
				_targetNode = model.path[model.path.length-1];
			}else
			{
				var lastPosition:Point = new Point(model.currentPosition.x,model.currentPosition.y) as Point;
				var lastSpeed:Point = new Point(model.speed.x,model.speed.y) as Point;
				
				var stepT:Point = new Point(model.currentPosition.x + model.speed.x,model.currentPosition.y + model.speed.y) as Point;
				var tar:Point = new Point(currentTarget.point.x - model.currentPosition.x,currentTarget.point.y - model.currentPosition.y) as Point;
				if(model.speed.length < tar.length)
				{
					//此步还不能到达
//					ResourceManager.instance.releaseResource(model.currentPosition);
					model.currentPosition = stepT;
				}else
				{
					if(!flagReach)
					{
//						ResourceManager.instance.releaseResource(model.currentPosition);
						model.currentPosition = new Point(currentTarget.point.x,currentTarget.point.y) as Point;
						
						if(currentTarget.city != null)
						{
							if(currentTarget.city.OwnerPlayEntity != (_entity as ArmyEntity).ownedPlayer)
							{
								var index:int = model.path.indexOf(currentTarget);
								if(index == (model.path.length -1))
								{
									//
								}else
								{
									//如果半路改变了，则将路径最后的部分删除。
									model.path.splice((index+1),(model.path.length-index-1));
								}
								
								_targetNode = currentTarget;
								
								(currentTarget.city.getComponentByName("cityRender") as ICityRender).showUnderAttack();
	
								flagReach = true;
	//							cityUnderAttack(currentTarget.city);
								
	//							//不是自己，发起攻击。
	//							(currentTarget.city.getComponentByName("cityLogic") as CityLogic).underArmyAttack(_entity as ArmyEntity);
	//							
	//							//从世界上移除这支队伍。
	//							(_entity as ArmyEntity).ownedPlayer.ownedWarzone.removeArmy((_entity as ArmyEntity));
	//							
	//							_entity.destory();
	//							return;
							}else
							{
								//是自己，并且是最终目标，将部队增加到此地。
								if(model.path.indexOf(currentTarget) == (model.path.length-1))
								{
									flagReach = true;
	//								cityUnderAttack(currentTarget.city);
									
	//								(currentTarget.city.getComponentByName("cityLogic") as CityLogic).underArmyAttack(_entity as ArmyEntity);
	//								
	//								//从世界上移除这支队伍。
	//								(_entity as ArmyEntity).ownedPlayer.ownedWarzone.removeArmy((_entity as ArmyEntity));
	//								
	//								_entity.destory();
	//								return;
								}
							}
							
						}
						
						currentIndex ++;
						if((currentIndex +1)<model.path.length)
						{
							
							//改变速度
							changeSpeed();
							//更换目标点。此处一定要先计算速度，后改变目标点。
							currentTarget = model.path[currentIndex + 1];
						}else
						{
//							ResourceManager.instance.releaseResource(model.speed);
							model.speed = new Point();
						}
					}
				}
				buildPathAndPoints(lastPosition,lastSpeed);
				
//				ResourceManager.instance.releaseResource(tar);
//				ResourceManager.instance.releaseResource(lastPosition);
//				ResourceManager.instance.releaseResource(lastSpeed);
				//判断下队尾是不是也到达了。
//				var targetP:Point = _targetNode.point;
				var lastP:PathPoint = pathes[pathes.length -1];
//				var len:Point = new Point(targetP.x - lastP.position.x,targetP.y-lastP.position.y);
				if(flagReach)
				{
					if(lastP.position.length < _targetNode.radius)
					{
						cityUnderAttack(_targetNode.city);
						return;
					}
				}
			}
			super.onTick(delTime);
		}
		
		private function cityUnderAttack(city:CityEntity):void
		{
			//不是自己，发起攻击。
			(city.getComponentByName("cityLogic") as CityLogic).underArmyAttack(_entity as ArmyEntity);
			
			//从世界上移除这支队伍。
			(_entity as ArmyEntity).ownedPlayer.ownedWarzone.removeArmy((_entity as ArmyEntity));
			
			var ar:IArmyRender = _entity.getComponentByName("armyRender") as IArmyRender;
			var al:ArmyLogic = _entity.getComponentByName("armyLogic") as ArmyLogic;
			var am:ArmyModel = _entity.Model as ArmyModel;
			
			ResourceManager.instance.releaseResource(ar);
			ResourceManager.instance.releaseResource(al);
			ResourceManager.instance.releaseResource(am);
			ResourceManager.instance.releaseResource(_entity);
			
			_entity.destory(false);
		}
		
		private function changeSpeed():void
		{
			var model:ArmyModel = _entity.Model as ArmyModel;
			
//			ResourceManager.instance.releaseResource(model.speed);
			if(model.path.length > (currentIndex+1))
			{
				model.speed = new Point(model.path[currentIndex+1].point.x - currentTarget.point.x,model.path[currentIndex+1].point.y - currentTarget.point.y) as Point;
				var ss:Number = ConfigManager.ArmySpeed*((_entity as ArmyEntity).ownedPlayer.Model as PlayerModel).army_speed;
				//如果是快速的，则速度乘以1.5.
				ss *= ((((_entity as ArmyEntity).fromCity.Model as CityModel).fast_armies)?1.5:1);
				ss *= ((_entity as ArmyEntity).ownedPlayer.Model as PlayerModel).getArmySpeedGain(((_entity as ArmyEntity).fromCity.Model as CityModel).type)
				model.speed.normalize(ss);
				if((currentTarget.layer == 2) && (model.path[currentIndex+1].layer == 2))
				{
					LandGrabbers.instance.warField.armyLayer2.addChild((_entity.getComponentByName("armyRender") as ArmyRender).ArmySprite);
				}else
				{
					LandGrabbers.instance.warField.armyLayer.addChild((_entity.getComponentByName("armyRender") as ArmyRender).ArmySprite);
				}
			}else
			{
				model.speed = new Point();
			}
		}
		
		/**
		 * 构建军队的所有士兵的位置和方向。
		 * 
		 */		
		private function buildPathAndPoints(lastPosition:Point,lastSpeed:Point):void
		{
			var model:ArmyModel = _entity.Model as ArmyModel;
			if(model)
			{
				//需要的队列的长度 减去旗帜的人。 显示一半的人数.
				var total:int = int(model.armyPopulation-1)/2;
				if(pathes.length >= ((total+2)*STEPFORARMY))
				{
					//如果位置已经够了，将最后两个去除。因为队列每次前进一个位置，即两个人的宽度。
					for(var j:int = 0;j<3;j++)
					{
						var pp1:PathPoint = pathes.pop();
//						ResourceManager.instance.releaseResource(pp1.position);
//						ResourceManager.instance.releaseResource(pp1.speed);
						ResourceManager.instance.releaseResource(pp1);
						pp1.position = null;
						pp1.speed = null;
						pp1 = null;
					}
				}
				//从当前前位置到上一个位置的向量。此处由于y是反的，y的计算和x的计算，不是一个方式。
				lastPathVector = new Point(lastPosition.x-model.currentPosition.x, -lastPosition.y + model.currentPosition.y) as Point;
				
				//垂直向量
				var cuizhiVector:Point;
				if(lastPathVector.y != 0)
				{
					cuizhiVector = new Point(1,-lastPathVector.x/lastPathVector.y) as Point;
					cuizhiVector.normalize(DISTANCE);
				}else
				{
					cuizhiVector = new Point(0,DISTANCE) as Point;
				}
				
				//移动所有点的相对位置。此点移动，则以前所有点的相对点必须移动。
				for each(var pathp:PathPoint in pathes)
				{
					pathp.position.x += lastPathVector.x;
					pathp.position.y += lastPathVector.y;
				}
				
				for(var i:int = 0;i<3;i++)
				{
					if(pathes.length < ((total+2)*STEPFORARMY))
					{
						//需要添加
						var pp:PathPoint = ResourceManager.instance.getResourceByType(PathPoint) as PathPoint;
						if(i<2)
						{
							pp.position = new Point(lastPathVector.x + ((i==0?1:-1)*cuizhiVector.x),lastPathVector.y + ((i==0?1:-1)*cuizhiVector.y)) as Point;
						}else
						{
							pp.position = new Point(2*lastPathVector.x,2*lastPathVector.y) as Point;
						}
						pp.speed = new Point(lastSpeed.x,lastSpeed.y) as Point;
						pathes.unshift(pp);
					}
				}
//				ResourceManager.instance.releaseResource(lastPathVector);
//				ResourceManager.instance.releaseResource(cuizhiVector);
			}
		}
		
		public override function destory(deep:Boolean = true):void
		{
			currentTarget = null;
			_targetNode = null;
			while(pathes.length >0)
			{
				var pp:PathPoint = pathes.pop();
//				ResourceManager.instance.releaseResource(pp.position);
//				ResourceManager.instance.releaseResource(pp.speed);
				ResourceManager.instance.releaseResource(pp);
				pp.position = null;
				pp.speed = null;
				pp = null;
			}
			deep && (pathes = null);
			if(!deep)
			{
				currentIndex = 0;
				attacking = false;
				flagReach = false;
			}
			super.destory(deep);
		}
		
	}
}