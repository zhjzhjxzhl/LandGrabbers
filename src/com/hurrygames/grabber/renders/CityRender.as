package com.hurrygames.grabber.renders
{
	import com.hurrygames.grabber.IRenders.ICityRender;
	import com.hurrygames.grabber.core.BaseRender;
	import com.hurrygames.grabber.core.IEntity;
	import com.hurrygames.grabber.core.IRender;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.entitys.PlayerEntity;
	import com.hurrygames.grabber.logics.CityLogic;
	import com.hurrygames.grabber.logics.PlayerLogic;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.LoopController;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.models.WarzoneModel;
	import com.hurrygames.grabber.utils.AnimationRender;
	import com.hurrygames.swc.MainUI.LevelUPBuildingButton;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * Project : LandGrabbers
	 * CityRender
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class CityRender extends BaseRender implements ICityRender
	{
		public var City:Sprite;
		
		protected var text:TextField;
		
		protected var levelUpButton:SimpleButton;
		
		protected var cityBitmap:DisplayObject;
		
		private var oldCityBitmap:DisplayObject;
		
		/**
		 * 当前渲染图的玩家id。为了玩家渲染图的变化而转变。 
		 */		
		protected var currentplayerId:int = -1;
		
		protected var currentLevel:int = -1;
		
		protected var currentPeople:int = 0;
		/**
		 * 选中的动画. 
		 */		
		private var Selected:AnimationRender;
//		/**
//		 *建筑的底盘 
//		 */		
//		private var dipan:dipan01 = new dipan01();
		
		private var selectorDisplay:DisplayObject;
		
		public function CityRender()
		{
			City = new Sprite();
			
			text = new TextField();
			levelUpButton = new LevelUPBuildingButton
			
			City.doubleClickEnabled = true;
			City.addChild(text);
			LandGrabbers.instance.warField.armyLayer2.addChild(levelUpButton);
//			City.addChild(levelUpButton);
		}
		
		override public function init(para:*):void
		{
			super.init(para);
			text.selectable = text.mouseEnabled  = false;
			var citye:CityEntity = para as CityEntity;
			if(citye)
			{
//				if((citye.OwnerPlayEntity.Model as PlayerModel).PlayerId == 1)
//				{
					//如果是自己，则添加升级功能。
					levelUpButton.addEventListener(MouseEvent.CLICK,LevelUp);
//				}
			}
			City.parent.addEventListener(MouseEvent.CLICK,selected);
			City.parent.addEventListener(MouseEvent.DOUBLE_CLICK,addArmytoOneCity);
//			City.addEventListener(MouseEvent.ROLL_OVER,showSelecteCity);
//			City.addEventListener(MouseEvent.ROLL_OUT,hideSelecteCity);
			City.parent.addEventListener(MouseEvent.MOUSE_MOVE,showOn);
			
			var model:CityModel = citye.Model as CityModel;
			City.x = model.pos.x;
			City.y = -model.pos.y;
			text.text = "p:"+model.current_population/*+"\n Lv:"+model.level*/;
//			var color:uint = ConfigManager.PlayerToColor[(citye.OwnerPlayEntity.Model as PlayerModel).PlayerId];
			text.defaultTextFormat = (new TextFormat(null,15,0xff00ff,3));
			text.width = text.textWidth + 24;
			text.height = text.textHeight + 4;
			text.x = -(text.width/2);
			text.filters = [new GlowFilter(0xffffff,1,4,4,6)];
			var p:Point = LandGrabbers.instance.warField.armyLayer2.globalToLocal(City.localToGlobal(new Point()));
			levelUpButton.x = 15+p.x;
			levelUpButton.y = -45+p.y;
		}
		
		override public function destory(deep:Boolean = true):void
		{
			levelUpButton.parent && (levelUpButton.parent.removeChild(levelUpButton));
			levelUpButton.removeEventListener(MouseEvent.CLICK,LevelUp);
			City.parent.removeEventListener(MouseEvent.CLICK,selected);
			City.parent.removeEventListener(MouseEvent.DOUBLE_CLICK,addArmytoOneCity);
//			City.removeEventListener(MouseEvent.ROLL_OVER,showSelecteCity);
//			City.removeEventListener(MouseEvent.ROLL_OUT,hideSelecteCity);
			City.parent.removeEventListener(MouseEvent.MOUSE_MOVE,showOn);
			
			City.doubleClickEnabled = false;
			City.parent.removeChild(City);
			removeSelected();
			if(underAttackAR)
			{
				ConfigManager.instance.releaseAnimationRender(underAttackAR);
				underAttackAR = null;
			}
		}
		
		private function showSelecteCity(e:MouseEvent):void
		{
			City.addEventListener(MouseEvent.MOUSE_MOVE,showOn);
		}
		private function showOn(e:MouseEvent):void
		{
			if(!realOn())
			{
				hideOn();
				return;
			}
			if(selectorDisplay)
			{
				if(selectorDisplay.parent == null)
				{
					City.addChildAt(selectorDisplay,(City.numChildren-2));
				}
				return;
			}
			
			if(((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId == 1)
			{
				//自己城市
				selectorDisplay = ConfigManager.instance.AnimationBitmaps["our_selector"];
			}else
			{
				var player:PlayerEntity = LandGrabbers.instance.warField.warzone.getPlayerById(1);
				if(player.getAdjoinCities().indexOf((LandGrabbers.instance.warField.warzone.Model as WarzoneModel).path_count_node[((_entity as CityEntity).Model as CityModel).count_node_number]) == -1)
				{
					return;
				}else
				{
					selectorDisplay = ConfigManager.instance.AnimationBitmaps["enemy_selector"];
				}
			}
			selectorDisplay.x = -65;
			selectorDisplay.y = -75;
			City.addChildAt(selectorDisplay,(City.numChildren-2));
		}
		
		private function hideSelecteCity(e:MouseEvent):void
		{
			hideOn();
			City.removeEventListener(MouseEvent.MOUSE_MOVE,showOn);
		}
		private function hideOn():void
		{
			if(selectorDisplay && selectorDisplay.parent)
			{
				selectorDisplay.parent.removeChild(selectorDisplay);
				selectorDisplay = null;
			}
		}
		
		private function realOn():Boolean
		{
			if(cityBitmap == null)
			{
				return false;
			}
			var bitmap:Bitmap;
			if(cityBitmap is Bitmap)
			{
				bitmap = cityBitmap as Bitmap;
			}else
			{
				bitmap = (cityBitmap as Loader).content as Bitmap;
			}
			if(bitmap == null)
			{
				return false;
			}
			
//			var color:uint = bitmap.bitmapData.getPixel32(bitmap.mouseX,bitmap.mouseY);
			var p:Point = bitmap.localToGlobal(new Point());
			return (bitmap.bitmapData.hitTest(p,0xff,new Point(City.stage.mouseX,City.stage.mouseY)));
		}
		
		private function addArmytoOneCity(e:MouseEvent):void
		{
			e.stopPropagation();
			if(!realOn())
			{
				return;
			}
			if((_entity as CityEntity).OwnerPlayEntity.selectedCities.indexOf(_entity) != -1)
			{
				(_entity as CityEntity).OwnerPlayEntity.removeOneSelectedCity(_entity as CityEntity);
				removeSelected();
			}
			//todo
			if(((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId == 1)
			{
				(LandGrabbers.instance.warField.warzone.getPlayerById(1).getComponentByName("playerLogic") as PlayerLogic).attackOneCityWithNode(_entity as CityEntity);
			}
		}
		
		private function selected(e:MouseEvent):void
		{
			e.stopPropagation();
			if(!realOn())
			{
				return;
			}
			if(((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId == 1)
			{
				if((_entity as CityEntity).OwnerPlayEntity.selectedCities.indexOf(_entity) != -1)
				{
					(_entity as CityEntity).OwnerPlayEntity.removeOneSelectedCity(_entity as CityEntity);
					removeSelected();
				}else
				{
//					text.filters = [new GlowFilter(0xffff00)];
					(_entity as CityEntity).OwnerPlayEntity.addOneSelectedCity(_entity as CityEntity);
					Selected = ConfigManager.instance.getAnimation("city_selector");
					Selected.x = -65;
					Selected.y = -65;
					City.addChildAt(Selected,0);
				}
			}else
			{
				//根据player1的所选部队攻击此建筑。
				//1号是玩家。
				var pe:PlayerEntity = LandGrabbers.instance.warField.warzone.getPlayerById(1);
				if(pe.getAdjoinCities().indexOf((pe.ownedWarzone.Model as WarzoneModel).path_count_node[(_entity.Model as CityModel).count_node_number]) != -1)
				{
					(LandGrabbers.instance.warField.warzone.getPlayerById(1).getComponentByName("playerLogic") as PlayerLogic).attackOneCityWithNode(_entity as CityEntity);
				}else
				{
					trace("不相邻，不能攻击...");
				}
			}
		}
		
		/**
		 * 纯粹是表现上的，不需要验证。 
		 * 
		 */		
		public function removeSelected():void
		{
			if(Selected)
			{
				City.removeChild(Selected);
				ConfigManager.instance.releaseAnimationRender(Selected);
//				Selected.stop();
				Selected = null;
			}
		}
		
		private function LevelUp(e:MouseEvent):void
		{
			//不再向后传播，以免导致城市进入选中状态。
			e.stopPropagation();
			var cl:CityLogic = _entity.getComponentByName("cityLogic") as CityLogic;
			cl.levelUp();
		}
		
		override public function render():void
		{
			var model:CityModel = _entity.Model as CityModel;
			if(currentPeople != model.current_population)
			{
				text.text = "p:"+int(model.current_population).toString()/*+"\n Lv:"+model.level*/;
				currentPeople = model.current_population;
			}
			if((model.level != currentLevel) || (currentplayerId != ((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId))
			{
				removeOldBitmap();
				showCity();
			}
			if(((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId == 1)
			{
				if(LandGrabbers.instance.warField.wz.max_upgrade_level > model.level)
				{
					levelUpButton.visible = (model.current_population >= (model.level * ConfigManager.populationPreLevel)/2);
				}else
				{
					levelUpButton.visible = false;
				}
			}else
			{
				levelUpButton.visible = false;
			}
			var logic:CityLogic = _entity.getComponentByName("cityLogic") as CityLogic;
			if(logic.levelUping)
			{
				levelUpButton.visible = false;
				if(levelUpAnimation == null)
				{
					levelUpAnimation = ConfigManager.instance.getAnimation("upgrade_city");
					levelUpAnimation.x = -65;
					levelUpAnimation.y = -115;
					levelUpAnimation.start();
					City.addChild(levelUpAnimation);
				}
			}else
			{
				if(levelUpAnimation)
				{
					City.removeChild(levelUpAnimation);
					ConfigManager.instance.releaseAnimationRender(levelUpAnimation);
					levelUpAnimation = null;
				}
			}
		}
		private var levelUpAnimation:AnimationRender;
		
		protected function showCity():void
		{
			var model:CityModel = _entity.Model as CityModel;
			if((model.level == currentLevel) && (((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId == currentplayerId))
			{
				//没有变化，不改变。
			}else
			{
				if(cityBitmap != null)
				{
					oldCityBitmap = cityBitmap;
				}
				
				var preString:String = "city";
				if(model.fortification)
				{
					preString = "castle";
				}else if(model.strong_armies)
				{
					preString = "forge";
				}else if(model.fast_armies)
				{
					preString = "stable";
				}else if(model.tower)
				{
					preString = "tower";
				}
				
				var path:String = /*ConfigManager.CITIES_PATH+*/preString+"_p"+
					((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId+"_s4_l"+model.level+"_zj"+
					((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).zhongzhu;
				cityBitmap =ConfigManager.instance.getCity(path);
//				cityBitmap.contentLoaderInfo.addEventListener(Event.COMPLETE,bitmapLoaded);
//				cityBitmap.load(new URLRequest(path));
				path = null;
				City.addChildAt(cityBitmap,0);
//				City.addChildAt(dipan,0);
//				dipan.x = -65;
//				dipan.y = -95;
				(Selected) && (City.addChildAt(Selected,0));
				cityBitmap.x = -65;
				cityBitmap.y = -95;
				
//				cityBitmap.mouseEnabled = false;
				
				currentLevel = model.level;
				currentplayerId = ((_entity as CityEntity).OwnerPlayEntity.Model as PlayerModel).PlayerId;
				removeOldBitmap();
			}
		}
		
		private function bitmapLoaded(e:Event):void
		{
			var loader:Loader = (e.target as LoaderInfo).loader;
			loader.removeEventListener(Event.COMPLETE,bitmapLoaded);
			removeOldBitmap();
		}
		
		private function removeOldBitmap():void
		{
			if(oldCityBitmap != null)
			{
				ConfigManager.instance.releaseCity(oldCityBitmap);
				if(oldCityBitmap.parent)
				{
					oldCityBitmap.parent.removeChild(oldCityBitmap);
				}
				oldCityBitmap = null;
			}
		}
		
		private var underAttackAR:AnimationRender;
		/**
		 *  此处只是显示被攻击效果。并不发生实质变化。 
		 * 
		 */		
		public function showUnderAttack():void
		{
			if(underAttackAR == null)
			{
				underAttackAR = ConfigManager.instance.getAnimation("capture_city");
				underAttackAR.x = -65;
				underAttackAR.y = -115;
				underAttackAR.start();
				underAttackAR.AnimationFinishedCallBack = underAttackFinished;
				City.addChild(underAttackAR);
			}
		}
		
		/**
		 * 停止攻击效果. 
		 * 
		 */		
		public function underAttackFinished():void
		{
			if(underAttackAR && underAttackAR.parent)
			{
				City.removeChild(underAttackAR);
				ConfigManager.instance.releaseAnimationRender(underAttackAR);
//				underAttackAR.stop();
				underAttackAR = null;
			}
		}
	}
} 
