package com.hurrygames.grabber.renders
{
	import com.hurrygames.grabber.IRenders.ITowerRender;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.logics.TowerAttackLogic;
	import com.hurrygames.grabber.logics.TowerLogic;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.utils.AnimationRender;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	import gs.TweenLite;
	
	/**
	 * Project : LandGrabbers
	 * TowerRender
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class TowerRender extends CityRender implements ITowerRender
	{	
		protected var towerPassiveAnimation:AnimationRender;
		
		protected var towerActiveAnimation:AnimationRender;
		
		/**
		 * 塔的攻击特效。 
		 */		
		protected var towerAttackAnimation:AnimationRender;
		
		protected var towerRange:Sprite = new Sprite();;
		
		
		public function TowerRender()
		{
			super();
		}
		
		override protected function showCity():void
		{
			super.showCity();
			//添加塔特效。
			var towerLogic:TowerAttackLogic = _entity.getComponentByName("towerAttackLogic") as TowerAttackLogic;
			
			var model:CityModel = _entity.Model as CityModel;
			var xx:Number = -67;
			var yy:Number = -105 - (model.level * 10);
			
			var range:Number = ConfigManager.TowerBaseRange + (_entity.Model as CityModel).level*ConfigManager.TowerRangePreLevel;
			//塔的攻击范围加成
			range *= ((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).getTowerRangeGain((_entity.Model as CityModel).type);
			
			towerRange.graphics.clear();
			towerRange.graphics.beginFill(0xff0000,0.2);
			towerRange.graphics.drawCircle(0,0,range);
			towerRange.graphics.endFill();
			City.addChild(towerRange);
			towerRange.mouseChildren = towerRange.mouseEnabled = false;
			
			if(towerLogic.IsActive)
			{
				if(towerActiveAnimation && towerActiveAnimation.stage)
				{
					(towerActiveAnimation.y != yy)&&(towerActiveAnimation.y = yy);
					return;
				}
			}else
			{
				if(towerPassiveAnimation && towerPassiveAnimation.stage)
				{
					(towerPassiveAnimation.y != yy)&&(towerPassiveAnimation.y = yy);
					return;
				}
			}
			if(!towerLogic.IsActive)
			{
				if(towerPassiveAnimation == null)
				{
					towerPassiveAnimation = ConfigManager.instance.getAnimation("tower_passive");
					towerPassiveAnimation.x = xx;
					towerPassiveAnimation.y = yy;
				}
				City.addChild(towerPassiveAnimation);
				
				if(towerActiveAnimation && (towerActiveAnimation.parent))
				{
					towerActiveAnimation.parent.removeChild(towerActiveAnimation);
					ConfigManager.instance.releaseAnimationRender(towerActiveAnimation);
					towerActiveAnimation = null;
				}
			}else
			{
				if(towerActiveAnimation == null)
				{
					towerActiveAnimation = ConfigManager.instance.getAnimation("tower_active");
					towerActiveAnimation.x = xx;
					towerActiveAnimation.y = yy;
				}
				City.addChild(towerActiveAnimation);
				
				if(towerPassiveAnimation && towerPassiveAnimation.parent)
				{
					ConfigManager.instance.releaseAnimationRender(towerPassiveAnimation);
					towerPassiveAnimation.parent.removeChild(towerPassiveAnimation);
					towerPassiveAnimation = null;
				}
			}
		}
		
		
		/**
		 * 攻击某个地方 
		 * @param position
		 * 
		 */		
		public function attackOnePosition(position:Point):void
		{
			var model:CityModel = _entity.Model as CityModel;
			var xx:Number = -67;
			var yy:Number = -105 - (model.level * 10);
			
//			if(towerAttackAnimation == null)
//			{
//				towerAttackAnimation = ConfigManager.instance.getAnimation("tower_shoot");
//				towerAttackAnimation.x = xx;
//				towerAttackAnimation.y = yy;
//			}
//			City.addChild(towerAttackAnimation);
//			towerAttackAnimation.start();
//			towerAttackAnimation.AnimationFinishedCallBack = attackFinishedCallBack;
			
			if(s == null)
			{
				s = new Shape();
			}
			s.x = City.x;
			s.y = City.y-41-model.level*10;
			
			LandGrabbers.instance.warField.effectLayer.addChild(s);
			s.graphics.clear();
			s.graphics.lineStyle(5,0xffffff);
			s.graphics.lineTo(position.x,position.y);
			
			TweenLite.to({},0.1,{"onComplete":function():void
			{
				if(s.parent)
				{
					s.parent.removeChild(s);
				}
			}});
		}
		private var s:Shape;
		
//		private function attackFinishedCallBack():void
//		{
//			if(towerAttackAnimation.parent)
//			{
//				towerAttackAnimation.parent.removeChild(towerAttackAnimation);
//			}
//			towerAttackAnimation.stop();
//		}
		
		override public function destory(deep:Boolean = true):void
		{
			super.destory(deep);
			if(towerPassiveAnimation)
			{
				if(towerPassiveAnimation.parent)
				{
					towerPassiveAnimation.parent.removeChild(towerPassiveAnimation);
				}
				ConfigManager.instance.releaseAnimationRender(towerPassiveAnimation);
//				towerPassiveAnimation.stop();
//				towerPassiveAnimation.destory();
				towerPassiveAnimation = null;
			}
			if(towerActiveAnimation)
			{
				if(towerActiveAnimation.parent)
				{
					towerActiveAnimation.parent.removeChild(towerActiveAnimation);
				}
				ConfigManager.instance.releaseAnimationRender(towerActiveAnimation);
//				towerActiveAnimation.stop();
//				towerActiveAnimation.destory();
				towerActiveAnimation = null;
			}
			if(towerAttackAnimation)
			{
				if(towerAttackAnimation.parent)
				{
					towerAttackAnimation.parent.removeChild(towerAttackAnimation);
				}
				ConfigManager.instance.releaseAnimationRender(towerAttackAnimation);
//				towerAttackAnimation.stop();
//				towerAttackAnimation.destory();
				towerAttackAnimation.AnimationFinishedCallBack = null;
				towerAttackAnimation = null;
			}
		}
	}
} 
