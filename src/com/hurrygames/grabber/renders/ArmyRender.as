package com.hurrygames.grabber.renders
{
	import com.hurrygames.grabber.IRenders.IArmyRender;
	import com.hurrygames.grabber.core.BaseRender;
	import com.hurrygames.grabber.entitys.ArmyEntity;
	import com.hurrygames.grabber.logics.ArmyLogic;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.LoopController;
	import com.hurrygames.grabber.managers.ResourceManager;
	import com.hurrygames.grabber.models.ArmyModel;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.utils.PathPoint;
	import com.hurrygames.grabber.utils.SoldierAnimation;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	
	/**
	 * Project : LandGrabbers
	 * ArmyRender
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ArmyRender extends BaseRender implements IArmyRender
	{
		public var ArmySprite:Sprite;
		
		/**
		 * 将所有的士兵都渲染到此bitmap上。 
		 */		
//		private var armybitMap:Bitmap;
		
		private var _currentSpeed:Point;
		
		/**
		 * 举旗的士兵 
		 */		
		private var flagSa:SoldierAnimation;
		
		/**
		 * 其它士兵 
		 */		
		private var otherSas:Vector.<SoldierAnimation> = new Vector.<SoldierAnimation>();
//		/**
//		 * 当前出到第几个兵位置了。 
//		 */		
//		private var armyIndex:int=0;
		
//		/**
//		 * 当前的位置。 
//		 */		
//		private var armyStep:int = 1;
		
		public function ArmyRender()
		{
			super();
			ArmySprite = new Sprite();
			ArmySprite.mouseChildren = ArmySprite.mouseEnabled = false;
//			armybitMap = new Bitmap(new BitmapData(256,256,true,0x0));
//			armybitMap.x = armybitMap.y = -128;
//			ArmySprite.addChild(armybitMap);
		}
		
		override public function render():void
		{
			var model:ArmyModel = _entity.Model as ArmyModel;
			var playerModel:PlayerModel = (_entity as ArmyEntity).ownedPlayer.Model as PlayerModel;
			var fromCity:CityModel = (_entity as ArmyEntity).fromCity.Model as CityModel;
			if(model && model.currentPosition && model.speed)
			{
				if(flagSa == null)
				{
					flagSa = ConfigManager.instance.getArmyAnimation(playerModel.PlayerId,fromCity.fast_armies,fromCity.strong_armies,true,playerModel.zhongzhu);
					ArmySprite.addChild(flagSa);
				}
				
				if(_currentSpeed /*&&((++armyStep)%STEPFORARMY == 0)*/)
				{
					//说明已经走了一步了，否者不做任何操作。
//					buildPathAndPoints();
					
					var pathes:Vector.<PathPoint> = (_entity.getComponentByName("armyLogic") as ArmyLogic).pathes;
					
					var total:int = int(pathes.length/ArmyLogic.STEPFORARMY)-2;
					total = (total<0)?0:total;
					var index:int = 0;
					while(otherSas.length<(total-1))
					{
						var osa:SoldierAnimation = ConfigManager.instance.getArmyAnimation(playerModel.PlayerId,fromCity.fast_armies,fromCity.strong_armies,false,playerModel.zhongzhu);
						otherSas.push(osa);
						ArmySprite.addChild(osa);
					}
					while((otherSas.length>0) && (otherSas.length>(total-1)))
					{
						var sa:SoldierAnimation = otherSas.pop();
						if(sa)
						{
							ConfigManager.instance.releaseAnimationRender(sa);
							ArmySprite.removeChild(sa);
							sa = null;
						}
					}
					for(var i:int = 0;i<=total;i+=3)
					{
						var start:int = i*3+9;
						var ol:int = otherSas.length;
						var pl:int = pathes.length;
						if(i>=ol || start>=pl)
						{
							break;
						}
						otherSas[i].setSpeed(pathes[start].speed);
						otherSas[i].x = pathes[start].position.x;
						otherSas[i].y = pathes[start].position.y;
						if((i+1)>=otherSas.length || (start+1)>=pl)
						{
							break;
						}
						otherSas[i+1].setSpeed(pathes[start+1].speed);
						otherSas[i+1].x = pathes[start+1].position.x;
						otherSas[i+1].y = pathes[start+1].position.y;
						if((i+2)>=otherSas.length || (start+2)>=pl)
						{
							break;
						}
						otherSas[i+2].setSpeed(pathes[start+2].speed);
						otherSas[i+2].x = pathes[start+2].position.x;
						otherSas[i+2].y = pathes[start+2].position.y;
					}
//					for(var i:int = STEPFORARMY;i<pathes.length;i+=STEPFORARMY)
//					{
//						var si:int = int(i/STEPFORARMY)-1;
//						if(otherSas.length < (si+1))
//						{
//							var osa:SoldierAnimation = ConfigManager.instance.getArmyAnimation(playerModel.PlayerId,fromCity.fast_armies,fromCity.strong_armies,false);
//							otherSas.push(osa);
////							ArmySprite.addChild(osa);
//						}
//						var ss:int = i /*+ (si%2)*/;
//						otherSas[si].setSpeed(pathes[ss].speed);
//						otherSas[si].x = pathes[ss].position.x;
//						otherSas[si].y = pathes[ss].position.y;
//						index = si;
//					}
//					if(otherSas.length > (index+1))
//					{
//						var sass:Vector.<SoldierAnimation> = otherSas.splice(index+1,otherSas.length-index-1);
//						while(sass.length>0)
//						{
//							var sa:SoldierAnimation = sass.pop();
//							ConfigManager.instance.releaseAnimationRender(sa);
//							sa = null;
//						}
//						sass = null;
//					}
				}
				
				
				
//				ResourceManager.instance.releaseResource(_currentSpeed);
				_currentSpeed = new Point(model.speed.x,model.speed.y) as Point;
				flagSa.setSpeed(_currentSpeed);
				
				ArmySprite.x = model.currentPosition.x-10;
				ArmySprite.y = -model.currentPosition.y - 20;
//				
////				sortChildren();
//				otherSas.push(flagSa);
//				//此处排序貌似可以省略。不太有意义。节省点性能。
////				otherSas.sort(function(s1:SoldierAnimation,s2:SoldierAnimation):int
////				{
////					return (s1.y-s2.y);
////				});
//				
//				armybitMap.bitmapData.lock();
//				armybitMap.bitmapData.fillRect(new Rectangle(0,0,256,256),0x00000000);
//				var rect:Rectangle = new Rectangle(0,0,otherSas[0].width,otherSas[0].height);
//				var len:int = otherSas.length;
//				for(var j:int = 0;j<len;j++)
//				{
////					armybitMap.bitmapData.copyPixels(otherSas[j].bitmapData,rect,new Point(otherSas[j].x+128,otherSas[j].y+128),null,null,true);
//					otherSas[j].render(armybitMap);
//				}
//				otherSas.splice(otherSas.indexOf(flagSa),1);
//				armybitMap.bitmapData.unlock();
				
			}
		}		
		
		
		override public function destory(deep:Boolean = true):void
		{
//			ResourceManager.instance.releaseResource(_currentSpeed);
			super.destory(deep);
			ArmySprite.parent.removeChild(ArmySprite);
			if(flagSa)
			{
				if(flagSa.parent)
				{
					ArmySprite.removeChild(flagSa);
				}
				ConfigManager.instance.releaseAnimationRender(flagSa);
//				flagSa.stop();
//				flagSa.destory();
				flagSa = null;
			}
			if(otherSas)
			{
				while(otherSas.length>0)
				{
					var sa:SoldierAnimation = otherSas.pop();
					if(sa.parent)
					{
						ArmySprite.removeChild(sa);
					}
					ConfigManager.instance.releaseAnimationRender(sa);
//					sa.stop();
//					sa.destory();
					sa = null;
				}
			}
			if(deep)
			{
//				if(armybitMap)
//				{
//					if(armybitMap.parent)
//					{
//						armybitMap.parent.removeChild(armybitMap);
//					}
//					armybitMap.bitmapData.dispose();
//					armybitMap.bitmapData = null;
//					armybitMap = null;
//				}
				ArmySprite = null;
				
				otherSas = null;
			}
		}
	}
} 
