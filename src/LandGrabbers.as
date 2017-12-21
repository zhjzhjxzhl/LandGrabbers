package
{
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
	import com.hurrygames.grabber.logics.CityLogic;
	import com.hurrygames.grabber.logics.PlayerAILogic;
	import com.hurrygames.grabber.logics.PlayerLogic;
	import com.hurrygames.grabber.logics.TowerAttackLogic;
	import com.hurrygames.grabber.logics.TowerLogic;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.ItemDescriptionManager;
	import com.hurrygames.grabber.managers.LoopController;
	import com.hurrygames.grabber.managers.POPUpManager;
	import com.hurrygames.grabber.managers.ResourceManager;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.managers.VersionConfig;
	import com.hurrygames.grabber.models.CityModel;
	import com.hurrygames.grabber.models.PlayerModel;
	import com.hurrygames.grabber.models.WarzoneModel;
	import com.hurrygames.grabber.renders.CityRender;
	import com.hurrygames.grabber.renders.TowerRender;
	import com.hurrygames.grabber.ui.BigAreaHelper;
	import com.hurrygames.grabber.ui.MainUIController;
	import com.hurrygames.grabber.ui.controller.UserInfoController;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.AnimationRender;
	import com.hurrygames.grabber.utils.Map;
	import com.hurrygames.grabber.utils.ObstacleDisplay;
	import com.hurrygames.grabber.utils.ServerCall;
	import com.hurrygames.grabber.utils.SoldierAnimation;
	import com.hurrygames.grabber.view.WarField;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
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
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	
	import gs.TweenLite;
	
//	import starling.core.Starling;
//	import starling.display.Image;
//	import starling.textures.Texture;
	
	[SWF(width="1000",height="600",frameRate="24",backgroundColor="#000000")]
	public class LandGrabbers extends Sprite
	{
		/**
		 * 游戏主要表现层 
		 */		
		public var contentLayer:Sprite;
		
		/**
		 * 游戏ui层 
		 */		
		public var uiLayer:Sprite;
		
		/**
		 * 游戏对话框层 
		 */		
		public var popupLayer:Sprite;
		
		/**
		 * 游戏提示框层 
		 */		
		public var alertLayer:Sprite;
		
		/**
		 * 游戏场景主内容。 
		 */		
		public var warField:WarField;
		
		private static var _instance:LandGrabbers;
		
		public static function get instance():LandGrabbers
		{
			return _instance;
		}
		
		public function LandGrabbers()
		{	
			_instance = this;
			
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function initParas():void
		{
			// TODO Auto Generated method stub
			if(stage.loaderInfo.parameters.hasOwnProperty("gateway"))
			{
				UrlConfig.GATE_WAY = stage.loaderInfo.parameters.gateway;
			}
			if(stage.loaderInfo.parameters.hasOwnProperty("resourceRoot"))
			{
				UrlConfig.RESOURCE_ROOT = stage.loaderInfo.parameters.resourceRoot;
			}
		}
		
		private function init(e:Event):void
		{
			
			initParas();
			ConfigManager.instance.initSkillConfig(Preloader.instance.bulkloader.get(UrlConfig.RESOURCE_ROOT+Preloader.XML_PATH+"skills.xml"+VersionConfig.getVersionString()).content as XML);
			ConfigManager.instance.initMagicsConfig(Preloader.instance.bulkloader.get(UrlConfig.RESOURCE_ROOT+Preloader.XML_PATH+"magics.xml"+VersionConfig.getVersionString()).content as XML);
			
			ItemDescriptionManager.instance.installEquipment(Preloader.instance.bulkloader.get(UrlConfig.RESOURCE_ROOT+Preloader.XML_PATH+"config_equipment.xml"+VersionConfig.getVersionString()).content as XML);
			ItemDescriptionManager.instance.installProduct(Preloader.instance.bulkloader.get(UrlConfig.RESOURCE_ROOT+Preloader.XML_PATH+"config_product.xml"+VersionConfig.getVersionString()).content as XML);
			
			
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			
//			this.stage.addChild(new FPSStats());
			
			contentLayer = new Sprite();
			uiLayer = new Sprite();
			popupLayer = new Sprite();
			alertLayer = new Sprite();
			
			this.addChild(contentLayer);
			this.addChild(uiLayer);
			this.addChild(popupLayer);
			this.addChild(alertLayer);
			if(Preloader.instance != null)
			{
//				loadOther();
				initGame();
			}
			
			POPUpManager.instance.initLayer(popupLayer);
			
//			this.stage.addEventListener(KeyboardEvent.KEY_UP,function(ke:KeyboardEvent):void
//			{
//				
//				switch(String.fromCharCode(ke.keyCode))
//				{
//					
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
		
		private function loadOther():void
		{
			UserInfoController.instance.GetUserInfo(getMapInfo);
		}
		
		private function getMapInfo():void
		{
			UserInfoController.instance.getMapInfo(getSkillInfo);
		}
		
		private function getSkillInfo():void
		{
			UserInfoController.instance.getSkillInfo(initGame);
			UserInfoController.instance.getHomeInfo();
			UserInfoController.instance.getUserEquipment();
			UserInfoController.instance.getUserBag();
		}
		
		private function getCurrentMasterInfo():void
		{
			//调用获取当前关的擂主
		}
		
		private function initGame():void
		{
			uiLayer.addChild(MainUIController.instance);
		}
		
		private var _loadingText:TextField = new TextField();
		private var _mask:Sprite = new Sprite();
		/**
		 * 根据传过来的一个0-1之间的值，显示进度。如果这个值为1，则自动消失 .此处用在关卡之间的切换load。
		 * @param precent
		 * 
		 */		
		public function showLoading(precent:Number):void
		{
			if(_mask.parent == null)
			{
				_mask.graphics.clear();
				_mask.graphics.beginFill(0x0);
				_mask.graphics.drawRect(0,0,1000,600);
				_mask.graphics.endFill();
				this.stage.addChild(_mask);
			}
			if(_loadingText.parent == null)
			{
				_loadingText.defaultTextFormat = new TextFormat(null,20,0xffffff,true);
				_loadingText.x = 480;
				_loadingText.y = 290;
				_mask.addChild(_loadingText);
			}
			_loadingText.text = (int(precent*10000)/100).toString()+"%";
			if(precent == 1)
			{
				this.stage.removeChild(_mask);
			}
		}
	}
}