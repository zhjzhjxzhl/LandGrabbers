package com.hurrygames.grabber.managers
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import com.hurrygames.grabber.config.Animation;
	import com.hurrygames.grabber.config.Animationhost;
	import com.hurrygames.grabber.config.BaseModel;
	import com.hurrygames.grabber.utils.AnimationRender;
	import com.hurrygames.grabber.utils.SoldierAnimation;
	import com.hurrygames.grabber.vo.magic.MagicVO;
	import com.hurrygames.grabber.vo.skill.SkillConfigVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Project : LandGrabbers
	 * ConfigManager
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ConfigManager
	{
		private static var _instance:ConfigManager;
		
		public static function get instance():ConfigManager
		{
			return (_instance == null)?(_instance = new ConfigManager()):_instance;
		}
		
		
		public static var BACKGROUND_PATH:String = "textures/war/backs/";
		
		public static var MUSIC_PATH:String = "sounds/music/";
		
		public static var EFFECT_PATH:String = "sounds/sfx/";
		
		public static var ANIMATION_PATH:String = "textures/war/animation/";
		
		public static var CITIES_PATH:String = "textures/war/cities/";
		
		public static var OBSTACLES_PATH:String = "textures/war/obstacles/";
		
		public static var OVERLAP_PATH:String = "textures/war/overlap/";
		
		public static var GUI_PATH:String = "textures/war/gui/";
		
		public static var TEXTURE_ROOT:String = "textures/war/";
		
		/**
		 *图标的目录 
		 */
		public static var ICON_ROOT:String = "textures/icon/";
		
		/**
		 *装备的目录 
		 */
		public static var EQUIPMENT_ROOT:String = "textures/equipment/";
		
		/**
		 * 图片的后缀 
		 */		
		public static const BitmapSuffix:String = ".png";
		
		/**
		 * AI 判定攻击的时间间隔的单位。为毫秒数。 此值越小，AI越厉害。
		 */		
		public static const AiAttackMS:Number = 200;
		
		/**
		 * AI最多可以派出的军队的数目.
		 */		
		public static const AIOwnedMaxArmyNumber:int = 10;
		
		/**
		 * 塔的最小攻击间隔。  毫秒数
		 */		
		public static const TowerAttackMs:Number = 100;
		
		/**
		 * 塔的初始范围。 
		 */		
		public static const TowerBaseRange:Number = 70;
		
		/**
		 * 每级增加的范围 
		 */		
		public static const TowerRangePreLevel:Number = 10;
		
		/**
		 * 城市人口增长一个单位的时间。 
		 */		
		public static const CityPeopleAddMs:Number = 400;
		
		/**
		 * 城市升级的时间。此处时间为秒数
		 */		
		public static const CityLevelUpTime:Number = 5;
		
		/**
		 * 军队的速度，每帧移动几个像素. 
		 */		
		public static const ArmySpeed:Number = 3;
		
		/**
		 * 每级容纳的人数. 
		 */		
		public static const populationPreLevel:int = 10;
		
		/**
		 * 玩家对应的颜色。 紫,红，绿，蓝,黄  紫色是中立玩家。红是玩家，绿蓝是别的。
		 */		
		public static const PlayerToColor:Array = [0xff00ff,0xff0000,0x0000ff,0x00ff00,0xffff00];
		
		/**
		 * 所有动画配置的索引。 
		 */		
		public var AnimationDictionary:Dictionary = new Dictionary();
		
		/**
		 * 所有动画的图片资源的索引。 
		 */		
		public var AnimationBitmaps:Dictionary = new Dictionary;
		
		/**
		 * 游戏的宽度 
		 */		
		public static const GAME_WIDTH:Number = 1000;
		
		/**
		 * 游戏的高度 
		 */		
		public static const GAME_HEIGHT:Number = 600;
		
		public function ConfigManager()
		{
		}
		
		/**
		 * 一个魔法配置数组，以id为key。后面是一个magicVO。 
		 */		
		public var magicsConfig:Dictionary = new Dictionary();
		
		/**
		 * 初始化魔法。 
		 * @param magics
		 * 
		 */		
		public function initMagicsConfig(magics:XML):void
		{
			for each(var magic:XML in magics.magic)
			{
				var mvo:MagicVO = new MagicVO();
				mvo.id = magic.@id;
				mvo.cd = magic.@cd;
				mvo.desc = magic.@desc;
				mvo.name = magic.@name;
				mvo.needDiamond = magic.@needDiamond;
				mvo.openLevel = magic.@openLevel;
				mvo.lastTime = magic.@lastTime;
				
				magicsConfig[mvo.id] = mvo;
			}
		}
		
		/**
		 * 一个技能的配置数组。以技能id_level为key。后面是一个 skillConfigVO
		 */		
		public var skillConfig:Dictionary = new Dictionary();
		
		/**
		 * 根据加载的配置初始化技能配置。 
		 */		
		public function initSkillConfig(skillsXml:XML):void
		{
			for each(var skill:XML in skillsXml.skill)
			{
				var scvo:SkillConfigVO = new SkillConfigVO();
				scvo.id = skill.@id;
				scvo.level = skill.@level;
				scvo.name = skill.@name;
				scvo.desc = skill.@desc;
				scvo.cityType = skill.@cityType;
				scvo.value = skill.@value;
				scvo.skillType = skill.@skillType;
				
				skillConfig[scvo.id+"_"+scvo.level] = scvo;
			}
		}
		
		
		/**
		 * 根据名字获得一个动画 
		 * @param animationName
		 * @return 
		 * 
		 */		
		public function getAnimation(animationName:String):AnimationRender
		{
			var ar:AnimationRender;
			if(_animationsPool[animationName])
			{
				ar = _animationsPool[animationName].pop();
			}
			if((ar == null)&&AnimationDictionary[animationName])
			{
				if(AnimationBitmaps[(AnimationDictionary[animationName] as Animation).texname])
				{
					ar = new AnimationRender(AnimationDictionary[animationName],(AnimationBitmaps[(AnimationDictionary[animationName] as Animation).texname] as Bitmap).bitmapData,animationName);
				}
			}else
			{
				ar.start();
			}
			return ar;
		}
		
		/**
		 * 获取一个军队中士兵的动画 
		 * @param playerId
		 * @param isFast
		 * @param isStrong
		 * @param isFlag
		 * @return 
		 * 
		 */		
		public function getArmyAnimation(playerId:int,isFast:Boolean,isStrong:Boolean,isFlag:Boolean,zhongzhu:int):SoldierAnimation
		{
			var sa:SoldierAnimation;
			
			var preString:String = "unit"+playerId;
			var am:Animation;
			if(isFast)
			{
				preString += "_fast";
				am = AnimationDictionary["unit_fast"] as Animation;
			}else if(isStrong)
			{
				preString += "_strong";
				var s:String = "unit_other"+((isFlag)?"_flag":"");
				am = AnimationDictionary[s] as Animation;
			}else if(!isFast && !isStrong)
			{
				preString += "_walk";
				var s1:String = "unit_other"+((isFlag)?"_flag":"");
				am = AnimationDictionary[s1] as Animation;
			}
			if(isFlag)
			{
				preString += "_flag";
			}
			preString += "_zj"+zhongzhu.toString();
			if(_animationsPool[preString])
			{
				sa = _animationsPool[preString].pop();
			}
			if(sa == null)
			{
				var bitmap:Bitmap = AnimationBitmaps[preString] as Bitmap;
				if(bitmap)
				{
					sa = new SoldierAnimation(am,bitmap.bitmapData,preString);
				}
			}else
			{
				sa.start();
			}
			preString = null;
			am = null;
			return sa;
		}
		
		private var _animationsPool:Dictionary = new Dictionary();
		
		/**
		 * 释放动画，回收起来，等待再次使用. 
		 * @param ar
		 * 
		 */		
		public function releaseAnimationRender(ar:AnimationRender):void
		{
			if(System.totalMemory > 200<<20)
			{
				clearAnimation();
				trace("内存大于200M，试图清理");
			}
			if(_animationsPool[ar.Aname] == null)
			{
				_animationsPool[ar.Aname] = new Vector.<AnimationRender>;
			}
			(_animationsPool[ar.Aname] as Vector.<AnimationRender>).push(ar);
			ar.AnimationFinishedCallBack = null;
			ar.stop();
		}
		
		/**
		 * 清除所有的动画资源。 
		 * 参数deep如果为true，则全部清除。否者给每种动画至少留一个实例。
		 */		
		public function clearAnimation(deep:Boolean=false):void
		{
			for(var name:String in _animationsPool)
			{
				var vector:Vector.<AnimationRender> = _animationsPool[name];
				var i:int = 1;
				if(deep)
				{
					i = 0;
					delete _animationsPool[name];
				}
				while(vector.length>i)
				{
					vector.pop().destory(deep);
				}
			}
		}
		
		/**
		 * 城市的图 
		 */		
		private var _cities:Dictionary = new Dictionary();
		
		public function getCity(url:String):DisplayObject
		{
			var dis:DisplayObject;
			
			if(_cities[url] != null)
			{
				dis = new Bitmap(_cities[url] as BitmapData);
				dis.name = url;
			}else
			{
				var c:Class = flash.utils.getDefinitionByName("com.hurrygames.landGrabbers.swc.City."+url) as Class;
				var p:MovieClip = new c() as MovieClip;
				dis = new Bitmap(new BitmapData(p.width,p.height,true,0x0));
				(dis as Bitmap).bitmapData.draw(p);
				dis.name = url;
			}
			return dis;
		}
		
		/**
		 * 释放一个city。 
		 * @param dis
		 * 
		 */		
		public function releaseCity(dis:DisplayObject):void
		{
			if(_cities[dis.name] != null)
			{
				//已经有这个缓存了，只是销毁
				if(dis is Bitmap)
				{
					(dis as Bitmap).bitmapData = null;
					dis = null;
				}
			}else
			{
				//将城市缓存起来。
				if(dis is Bitmap)
				{
					_cities[dis.name] = (dis as Bitmap).bitmapData;
					(dis as Bitmap).bitmapData = null;
					dis = null;
				}
			}
		}
		
	}
} 
