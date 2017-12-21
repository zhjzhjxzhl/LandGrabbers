package com.hurrygames.grabber.view
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import com.hurrygames.grabber.IRenders.ICityRender;
	import com.hurrygames.grabber.config.BaseModel;
	import com.hurrygames.grabber.config.City;
	import com.hurrygames.grabber.config.Obstacle;
	import com.hurrygames.grabber.config.Path_count_node;
	import com.hurrygames.grabber.config.Player;
	import com.hurrygames.grabber.config.Warzone;
	import com.hurrygames.grabber.entitys.CityEntity;
	import com.hurrygames.grabber.entitys.PlayerEntity;
	import com.hurrygames.grabber.entitys.WarzoneEntity;
	import com.hurrygames.grabber.events.CityEvent;
	import com.hurrygames.grabber.logics.CityLogic;
	import com.hurrygames.grabber.logics.PlayerAILogic;
	import com.hurrygames.grabber.logics.PlayerLogic;
	import com.hurrygames.grabber.logics.TowerAttackLogic;
	import com.hurrygames.grabber.logics.TowerLogic;
	import com.hurrygames.grabber.managers.CenterEventDispatcher;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.FightTimerController;
	import com.hurrygames.grabber.managers.LoopController;
	import com.hurrygames.grabber.managers.ResourceManager;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.managers.VersionConfig;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.models.WarzoneModel;
	import com.hurrygames.grabber.renders.CityRender;
	import com.hurrygames.grabber.renders.TowerRender;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.AnimationRender;
	import com.hurrygames.grabber.utils.Map;
	import com.hurrygames.grabber.utils.ObstacleDisplay;
	import com.hurrygames.grabber.utils.SoldierAnimation;
	import com.hurrygames.grabber.vo.skill.SkillConfigVO;
	import com.hurrygames.grabber.vo.skill.SkillVO;
	import com.hurrygames.grabber.vo.skill.UserSkillsVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import gs.TweenLite;
	
	
	/**
	 * Project : LandGrabbers
	 * WarField
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class WarField extends Sprite
	{
		/**
		 * 背景后面的动画层. 
		 */		
		public var lowBackAnimationLayer:Sprite;
		
		/**
		 * 背景层 
		 */		
		public var backGroundLayer:Sprite;
		
		/**
		 * 背景的位图. 
		 */		
		public var _backGroundBitMap:Bitmap;
		
		//城市层
		public var cityLayer:Sprite;
		
		// 道路层
		private var pathLayer:Sprite;
		
		public var map:Map;
		
		//寻路显示层
		private var findPathLayer:Sprite;
		
		//军队层
		public var armyLayer:Sprite;
		
		/**
		 * 第二军队层。此层位于overlap层之上。为了做出过桥效果。
		 */
		public var armyLayer2:Sprite;
		
		//特效层
		public var effectLayer:Sprite;
		
		//顶层.
		public var overlapLayer:Sprite;
		
		public var warzone:WarzoneEntity;
		
		public var wz:Warzone;
		
		private var _bulkLoader:BulkLoader = new BulkLoader();
		
		/**
		 * 此地图加载的大区域 
		 */		
		public var bigArea:int;
		
		/**
		 * 此地图加载的小区域。 
		 */		
		public var smallArea:int;
		
		CONFIG::GPU
		{
			public var myStarling:Starling;
		}
		
		public static const MAP_NAME:Array = ["forest","prairie","fjord","island","lava"];
		
		public function WarField()
		{
//			this.scaleX = 1000/1280;
//			this.scaleY = 600/768;
		}
		
		/**
		 * 加载地图，按照大地图和小地图区域。 
		 * @param bigArea
		 * @param smallArea
		 * 
		 */		
		public function loadOther(bigArea:int,smallArea:int,hardLevel:int):void
		{
			LoopController.instance.stop = true;
			
			this.bigArea = bigArea;
			this.smallArea = smallArea;
			
			if(CONFIG::GPU)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				
				myStarling = new Starling(GPULayer,this.stage);
				myStarling.antiAliasing = 1;
				myStarling.start();
			}
			
			lowBackAnimationLayer = new Sprite();
			lowBackAnimationLayer.mouseChildren = lowBackAnimationLayer.mouseEnabled = false;
			
			backGroundLayer = new Sprite();
			backGroundLayer.mouseChildren = backGroundLayer.mouseEnabled = false;
			
			cityLayer = new Sprite();
			cityLayer.x = ConfigManager.GAME_WIDTH/2;
			cityLayer.y = ConfigManager.GAME_HEIGHT/2;
			
			pathLayer = new Sprite();
			pathLayer.mouseChildren = pathLayer.mouseEnabled = false;
			pathLayer.x = cityLayer.x;
			pathLayer.y = cityLayer.y;
			pathLayer.scaleY = -1;
			
//			findPathLayer = new Sprite;
//			findPathLayer.mouseChildren = findPathLayer.mouseEnabled = false;
//			findPathLayer.x = cityLayer.x;
//			findPathLayer.y = cityLayer.y;
//			findPathLayer.scaleY = -1;
			
			armyLayer = new Sprite();
			armyLayer.mouseChildren = armyLayer.mouseEnabled = false;
			armyLayer.x = cityLayer.x;
			armyLayer.y = cityLayer.y;
			
			effectLayer = new Sprite();
			effectLayer.mouseChildren = effectLayer.mouseEnabled = false;
			effectLayer.x = cityLayer.x;
			effectLayer.y = cityLayer.y;
			
			overlapLayer = new Sprite();
			overlapLayer.mouseChildren = overlapLayer.mouseEnabled = false;
			
			armyLayer2 = new Sprite();
			/*armyLayer2.mouseChildren = */armyLayer2.mouseEnabled = false;
			armyLayer2.x = cityLayer.x;
			armyLayer2.y = cityLayer.y;
			
			
			lowBackAnimationLayer.x = cityLayer.x;
			lowBackAnimationLayer.y = cityLayer.y;
			
			this.addChild(lowBackAnimationLayer);
			
			this.addChild(backGroundLayer);
			
			this.addChild(pathLayer);
			
			this.addChild(armyLayer);
			
			this.addChild(overlapLayer);
			
			this.addChild(cityLayer);
			
			
			this.addChild(armyLayer2);
//			
//			this.addChild(findPathLayer);
			
			this.addChild(effectLayer);
			
//			cityLayer.scaleY = -1;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE,com);
			var levelConfigUrl:String = UrlConfig.RESOURCE_ROOT+ "scripts/levels/st"+(bigArea+1)+"_"+MAP_NAME[bigArea]+"0"+(smallArea+1)/*+"_hl"+hardLevel.toString()*/+".txt"+VersionConfig.getVersionString();
			trace("加载："+levelConfigUrl);
			loader.load(new URLRequest(levelConfigUrl));
			LandGrabbers.instance.showLoading(0);
			
			map = new Map();
			
			//统计一个显示对象容器总共有多少个child；
//			var f:Function = function(disc:DisplayObjectContainer):int
//			{
//				var nc:int = disc.numChildren;
//				var nn:int = nc;
//				for(var a:int = 0;a<nc;a++)
//				{
//					var c:DisplayObject = disc.getChildAt(a);
//					if(c is DisplayObjectContainer)
//					{
//						nn += f(c);
//					}
//				}
//				return nn;
//			};
//			
//			this.stage.addEventListener(KeyboardEvent.KEY_UP,function(ke:KeyboardEvent):void
//			{
//				
//				trace(String.fromCharCode(ke.keyCode));
//				switch(String.fromCharCode(ke.keyCode))
//				{
//					case "p":
//					case "P":
//						LoopController.instance.stop = true;
//						break;
//					case "r":
//					case "R":
//						LoopController.instance.stop = false;
//						break;
//					case "t":
//					case "T":
//						trace("目前舞台上有显示对象："+f(stage)+"个");
//						break;
//					case "s":
//					case "S":
//						if(armyLayer.parent)
//						{
//							removeChild(armyLayer);
//							removeChild(cityLayer);
//							for(var a:int = 0;a<8;a++)
//							{
//								var ar:AnimationRender = ConfigManager.instance.getAnimation("tower_passive");
//								ar.x = Math.random()*800;
//								ar.y = Math.random()*700;
//								addChild(ar);
//							}
//						}else
//						{
//							addChildAt(armyLayer,2);
//							addChildAt(cityLayer,3);
//						}
//						break;
//					case "1":
//						stage.quality = StageQuality.LOW;
//						break;
//					case "2":
//						stage.quality = StageQuality.MEDIUM;
//						break;
//					case "3":
//						stage.quality = StageQuality.HIGH;
//						break;
//					case "4":
//						stage.quality = StageQuality.BEST;
//						break;
//					case "f":
//					case "F":
//						if(stage.displayState == StageDisplayState.NORMAL)
//						{
//							stage.displayState = StageDisplayState.FULL_SCREEN;
//						}else
//						{
//							stage.displayState = StageDisplayState.NORMAL;
//						}
//						break;
//					default:
//						break;
//				}
//			});
		}
		
		private function com(e:Event):void
		{
			warzone = new WarzoneEntity();
			
			var model:BaseModel = new BaseModel((e.target as URLLoader).data);
			wz = model.warzone;
			
			warzone.addComponent(new WarzoneModel(wz.getLineString()),null);
			wz = warzone.Model as WarzoneModel;
			
			initPlayerAndCity(wz);
			
			drawPath(wz);
			
			LandGrabbers.instance.showLoading(0.05);
			_bulkLoader.addEventListener(BulkProgressEvent.PROGRESS,loadingProgress);
			_bulkLoader.addEventListener(BulkProgressEvent.COMPLETE,loadingComplete);
			_bulkLoader.addEventListener("error",loadingError);
			
			loadBackGround(wz);
			//加载前景，暂时去掉
//			loadOverLap(wz);
			//加载背后动画，暂时去掉。
//			loadobstacles(wz);
			
			_bulkLoader.start(2);
			
			map.init(wz.path_count_node);
			
//			initPathFindListener(wz);
		}
		
		protected function loadingError(event:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
		}
		
		protected function loadingComplete(event:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
			var m:MovieClip = _bulkLoader.get(UrlConfig.RESOURCE_ROOT+ConfigManager.BACKGROUND_PATH+wz.background_texture+".swf"+VersionConfig.getVersionString()).content as MovieClip;
			BackGroundLoaded(m);
			var ii:ImageItem = _bulkLoader.get(UrlConfig.RESOURCE_ROOT+ConfigManager.OVERLAP_PATH+wz.background_texture+"u"+ConfigManager.BitmapSuffix+VersionConfig.getVersionString()) as ImageItem;
			if(ii)
			{
				var b:DisplayObject = ii.content as DisplayObject;
				b.x = 128;
				overlapLayer.addChild(b);
			}
			_bulkLoader.clear();
			//加载完成开始逻辑。
			LoopController.instance.stop = false;
			FightTimerController.instance.reset();
		}
		
		protected function loadingProgress(event:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
			LandGrabbers.instance.showLoading(event.weightPercent);
		}
		
		private function initPlayerAndCity(wz:Warzone):void
		{
			var players:Vector.<PlayerEntity> = new Vector.<PlayerEntity>();
			
			for(var i:int = 0;i<wz.player.length;i++)
			{
				if(i == 1)
				{
					//如果id是1，则在此处插入一个玩家。后面的id依次往后推。
					var oplayer:PlayerEntity = new PlayerEntity();
					oplayer.addComponent(new PlayerModel((wz.player[i] as Player).getLineString()),null);
					
					oplayer.addComponent(new PlayerLogic(),"playerLogic");
					(oplayer.Model as PlayerModel).PlayerId = i;
					//玩家不加Ai。
					oplayer.ownedWarzone = warzone;
					players.push(oplayer);
					
					initPlayerSkill(oplayer,UserProfile.instance.userSkills);
					
					(oplayer.Model as PlayerModel).setEquipments(UserProfile.instance.userEquipments);
				}
				var player:PlayerEntity = new PlayerEntity();
				player.addComponent(new PlayerModel((wz.player[i] as Player).getLineString()),null);
				(player.Model as PlayerModel).PlayerId = i+(i>=1?1:0);
				player.addComponent(new PlayerLogic(),"playerLogic");
				//如果不是玩家，并且需要AI.
				if(((wz.player[i] as Player).ai_attack_delay > 0))
				{
					//					player.addComponent(new PlayerAILogic((player.Model as PlayerModel).ai_attack_delay*ConfigManager.AiAttackMS),"playerAI");
					/////////////////////////先一起攻击，测试性能。/////////////////
					TweenLite.to({},i*2,{"onComplete":function(ii:int,ply:PlayerEntity):void
					{
						trace(ii);
						ply.addComponent(new PlayerAILogic((wz.player[ii] as Player).ai_attack_delay*ConfigManager.AiAttackMS),"playerAI");
					},"onCompleteParams":[i,player]});
				}
				player.ownedWarzone = warzone;
				players.push(player);
			}
			warzone.players = players;
			
			for(var j:int = 0;j<wz.city.length;j++)
			{
				var c:City = wz.city[j] as City;
				
				var city:CityEntity = new CityEntity();
				warzone.cities.push(city);
				city.OwnerPlayEntity = players[c.owner];
				city.OwnerPlayEntity.addOneCity(city);
				
				
				((players[c.owner] as PlayerEntity).Model as PlayerModel).addCity(city);
				
				city.addComponent(new CityModel(c.getLineString()),null);
				
				var cl:CityLogic;
				
				var cr:ICityRender ;
				if((city.Model as CityModel).tower)
				{
					cl = new TowerLogic(ConfigManager.CityPeopleAddMs);
					if(CONFIG::GPU)
					{
						cr = new GPUTowerRender();
						GPULayer.instance.cityLayer.addChild((cr as GPUTowerRender).City);
					}else
					{
						cr = new TowerRender();
						cityLayer.addChild((cr as TowerRender).City);
					}
					
					var tal:TowerAttackLogic = new TowerAttackLogic(ConfigManager.TowerAttackMs);
					city.addComponent(tal,"towerAttackLogic");
				}else
				{
					cl = new CityLogic(ConfigManager.CityPeopleAddMs);
					if(CONFIG::GPU)
					{
						cr = new GPUCityRender();
						GPULayer.instance.cityLayer.addChild((cr as GPUCityRender).City);
					}else
					{
						cr = new CityRender();
						cityLayer.addChild((cr as CityRender).City);
					}
				}
				
				city.addComponent(cl,"cityLogic");
				
				city.addComponent(cr,"cityRender");
				
				(wz.path_count_node[(city.Model as CityModel).count_node_number] as Path_count_node).city = city;
				
				trace(j+"::"+c.pos.x+":::"+c.pos.y);
			}
			CenterEventDispatcher.instance.dispatchEvent(new CityEvent(CityEvent.SEIZE_ONE_CITY));
		}
		
		private function initPlayerSkill(oplayer:PlayerEntity, userSkills:UserSkillsVO):void
		{
			// TODO Auto Generated method stub
			var playerM:PlayerModel = oplayer.Model as PlayerModel;
			for each(var skill:SkillVO in userSkills.Skills)
			{
				var scvo:SkillConfigVO = ConfigManager.instance.skillConfig[skill.skillId+"_"+skill.skillLevel];
				playerM.skills[scvo.cityType][scvo.skillType] *= scvo.value;
			}
		}
		
		private function drawPath(wz:Warzone):void
		{
			for each(var pn:Path_count_node in wz.path_count_node)
			{
				pathLayer.graphics.beginFill(0x444444);
				pathLayer.graphics.drawCircle(pn.point.x,pn.point.y,pn.radius);
				pathLayer.graphics.endFill();
				pathLayer.graphics.lineStyle(2,0xffff00);
				for each(var eg:int in pn.edge)
				{
					pathLayer.graphics.moveTo(pn.point.x,pn.point.y);
					pathLayer.graphics.lineTo((wz.path_count_node[eg] as Path_count_node).point.x,(wz.path_count_node[eg] as Path_count_node).point.y);
				}
				pathLayer.graphics.lineStyle();
				
			}
		}
		
		/**
		 * 加载地图背后的东西 
		 * @param wz
		 * 
		 */		
		private function loadobstacles(wz:Warzone):void
		{
			for each(var obs:Obstacle in wz.obstacle)
			{
				if(obs.layer == -1)
				{
					var o:ObstacleDisplay = new ObstacleDisplay(obs);
					lowBackAnimationLayer.addChild(o);
					//					break;
				}
			}
		}
		
		/**
		 * 加载地图上层. 
		 * @param wz
		 * 
		 */		
		private function loadOverLap(wz:Warzone):void
		{
//			var loader:Loader = new Loader();
//			loader.x = 128;
//			overlapLayer.addChild(loader);
//			loader.load(new URLRequest(ConfigManager.OVERLAP_PATH+wz.background_texture+"u"+ConfigManager.BitmapSuffix));
			var overLayer:String = "";
			for each(var o:Obstacle in wz.obstacle)
			{
				if(o.layer == 1)
				{
					overLayer = o.texture;
				}
			}
			if(overLayer != "")
			{
				_bulkLoader.add(UrlConfig.RESOURCE_ROOT+ConfigManager.OVERLAP_PATH+overLayer+ConfigManager.BitmapSuffix+VersionConfig.getVersionString());
			}
		}
		
		/**
		 * 加载背景层. 
		 * @param wz
		 * 
		 */		
		private function loadBackGround(wz:Warzone):void
		{
//			var loader:Loader = new Loader();
//			//			if(!CONFIG::GPU)
//			//			{
//			//				loader.x = 128;
//			//				loader.y = -128;
//			//				loader.mouseChildren = loader.mouseEnabled = false;
//			//				backGroundLayer.addChild(loader);
//			//			}
//			
//			loader.load(new URLRequest(ConfigManager.BACKGROUND_PATH+wz.background_texture+".swf"));
//			if(!CONFIG::GPU)
//			{
//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,BackGroundLoaded);
//			}
			_bulkLoader.add(UrlConfig.RESOURCE_ROOT+ConfigManager.BACKGROUND_PATH+wz.background_texture+".swf"+VersionConfig.getVersionString());
		}
		
		private function BackGroundLoaded(loader:IBitmapDrawable):void
		{
//			var loader:Loader = (e.target as LoaderInfo).loader;
//			trace("loader width" + loader.width);
//			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,BackGroundLoaded);
			_backGroundBitMap = new Bitmap(new BitmapData(1000,600,true,0x0));
			_backGroundBitMap.bitmapData.lock();
			_backGroundBitMap.bitmapData.draw(loader);
//			_backGroundBitMap.bitmapData.draw(loader,(new Matrix(Math.cos(-Math.PI/2),Math.sin(-Math.PI/2),-Math.sin(-Math.PI/2),Math.cos(-Math.PI/2),(1280-128),768)),null,null/*,(new Rectangle((768),0,128,768))*/);
//			_backGroundBitMap.bitmapData.draw(loader,(new Matrix(1,0,0,1,128,-128)),null,null,(new Rectangle(128,0,1024,768)));
//			_backGroundBitMap.bitmapData.draw(loader,(new Matrix(Math.cos(-Math.PI/2),Math.sin(-Math.PI/2),-Math.sin(-Math.PI/2),Math.cos(-Math.PI/2),-(768+128),768)),null,null,(new Rectangle(0,0,128,768)));
			_backGroundBitMap.bitmapData.unlock();
			backGroundLayer.addChild(_backGroundBitMap);
			
			
//			loader.unloadAndStop();
			
			if(CONFIG::GPU)
			{
				var bitmap:Bitmap = loader.content as Bitmap;
				
				var t:Texture = Texture.fromBitmap(bitmap);
				var image:Image = new Image(t);
				image.x = -25;
				image.y = -130;
				GPULayer.instance.addChildAt(image,0);
			}
		}
		
		private var start_node:Path_count_node;
		private function initPathFindListener(wz:Warzone):void
		{
			pathLayer.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			{
				var p:Point = new Point(e.localX,e.localY);
				var node:Path_count_node = findNodeAtPoint(p,wz);
				if(node)
				{
					if(start_node == null)
					{
						findPathLayer.graphics.clear();
					}
					findPathLayer.graphics.beginFill(0xff0000);
					findPathLayer.graphics.drawCircle(node.point.x,node.point.y,10);
					findPathLayer.graphics.endFill();
					
					if(start_node)
					{
						map.buildPath(start_node.number);
						drawPathForNode(node,start_node);
						
						start_node = null;
					}else
					{
						start_node = node;
					}
				}
			});
		}
		
		private function findNodeAtPoint(p:Point,wz:Warzone):Path_count_node
		{
			for each(var node:Path_count_node in wz.path_count_node)
			{
				var p1:Point = new Point(node.point.x-p.x,node.point.y-p.y);
				if(p1.length < node.radius)
				{
					//找到了点击的点
					return node;
				}
			}
			return null;
		}
		
		public function drawPathForNode(end:Path_count_node,start:Path_count_node,color:uint = 0x0):void
		{
			findPathLayer.graphics.lineStyle(2,(color==0x0)?0xff0000:color);
			findPathLayer.graphics.moveTo(end.point.x,end.point.y);
			var current:Path_count_node = end.preNode;
			while((current!= null))
			{
				findPathLayer.graphics.lineTo(current.point.x,current.point.y);
				current = current.preNode;
			}
		}
		
		public function destory():void
		{
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			_backGroundBitMap.bitmapData.dispose();
			_backGroundBitMap.bitmapData = null;
			_backGroundBitMap = null;
			warzone.destory();
		}
	}
} 
