package
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import com.hurrygames.grabber.config.Animation;
	import com.hurrygames.grabber.config.Animationhost;
	import com.hurrygames.grabber.config.BaseModel;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.managers.VersionConfig;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * Project : LandGrabbers
	 * Preloader
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	[SWF(width="1000",height="600",frameRate="24",backgroundColor="#000000")]
	public class Preloader extends Sprite
	{
		/**
		 * buildmarker 生成的版本号。 
		 */		
		[Embed(source="../.version",mimeType="application/octet-stream")]
		private var versionXML:Class;
		
		private static var _instance:Preloader;
		
		/**
		 * 所有动画配置的索引。 
		 */		
		public var AnimationDictionary:Dictionary= new Dictionary();
		
		/**
		 * 所有动画的图片资源的索引。 
		 */		
		public var AnimationBitmaps:Dictionary = new Dictionary();
		
		public static var TEXTURE_ROOT:String = "textures/war/";
		
		/**
		 * 图片的后缀 
		 */		
		public static const BitmapSuffix:String = ".png";
		
		
		public static var OBSTACLES_PATH:String = "textures/war/obstacles/";
		
		public static var XML_PATH:String = "Configs/";
		
		public static const fils:Array = [
			new ColorMatrixFilter([
				0,0,0,0,68,
				0,0,0,0,141,
				0,0,0,0,255,	
				0,0,0,1,0
			]),
			new ColorMatrixFilter([
				0,0,0,0,245,
				0,0,0,0,82,
				0,0,0,0,58,	
				0,0,0,1,0
			]),
			new ColorMatrixFilter([
				0,0,0,0,255,
				0,0,0,0,189,
				0,0,0,0,71,	
				0,0,0,1,0
			]),
			new ColorMatrixFilter([
				0,0,0,0,99,
				0,0,0,0,255,
				0,0,0,0,105,	
				0,0,0,1,0
			])
		];
		
		public static function get instance():Preloader
		{
			return _instance;
		}
		
		public function Preloader()
		{
			super();
			
			//加入版本号支持
			var version:XML = new XML((new versionXML()).toString());
			var menu:ContextMenu = new ContextMenu();
			stage.showDefaultContextMenu = false;
			var menuItem:ContextMenuItem = new ContextMenuItem("releaseVersion:"+version.release.@count+"|time:"+version.release.@time);
			menuItem.enabled = false;
			menu.customItems.push(menuItem);
			menu.hideBuiltInItems();
			contextMenu = menu;
			
			//发布版本。
			VersionConfig.Version = version.release.@count;
			
			initParas();
			
			_instance = this;
			loadAnimationConfig(loadFinished);
			
			this.stage.scaleMode = StageScaleMode.SHOW_ALL;
//			this.stage.align = StageAlign.LEFT;
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xffffff);
			mask.graphics.drawRect(0,0,1000,600);
			mask.graphics.endFill();
			this.mask = mask;
			this.stage.addChild(mask);
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
		
		private var _callBack:Function;
		public function loadAnimationConfig(finishedCallBack:Function,fromLandGrabber:Boolean = false):void
		{
			_callBack = finishedCallBack;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,animationLoaded);
			loader.load(new URLRequest(UrlConfig.RESOURCE_ROOT +"scripts/hosts/animationhost.txt"+VersionConfig.getVersionString()));
			if(fromLandGrabber)
			{
				swfLoaded.splice(swfLoaded.indexOf("LandGrabbers.swf"),1);
			}
		}
		/**
		 *动画的资源数组 
		 */		
		private var bitmaps:Array = [
//			"unit1_fast","unit1_fast_flag","unit1_strong","unit1_strong_flag","unit1_walk","unit1_walk_flag",
//			"unit2_fast","unit2_fast_flag","unit2_strong","unit2_strong_flag","unit2_walk","unit2_walk_flag",
//			"unit3_fast","unit3_fast_flag","unit3_strong","unit3_strong_flag","unit3_walk","unit3_walk_flag",
//			"unit4_fast","unit4_fast_flag","unit4_strong","unit4_strong_flag","unit4_walk","unit4_walk_flag"
		];
		
		private var armyAnims:Array = [
			"unit1_fast","unit1_fast_flag","unit1_strong","unit1_strong_flag","unit1_walk","unit1_walk_flag"
		];
		private var obstacles:Array = ["cloud_tile","lava","water_tile","water_tile_gag"];
		
		private var textureRoot:Array = ["enemy_selector","our_selector"];
		
		private var swfLoaded:Array = [
			"Animation.swf"/*,"Animation1.swf","Animation2.swf","Animation3.swf","Animation4.swf"*/,"Animation5.swf","Animation6.swf","PeopleAnimation.swf","City.swf","MainUI.swf","FightUI.swf",
			"BigAreaSelector.swf","FriendList.swf","SkillAndRank.swf","HomeUI.swf","HomeContent.swf","People.swf","Message.swf","EquipmentAndBag.swf","LandGrabbers.swf"
		];
		
		private var xmlConfigs:Array = [
											"skills.xml","magics.xml","config_equipment.xml","config_product.xml"
										];
		
		public var bulkloader:BulkLoader = new BulkLoader("preloader",1);
		
		private function animationLoaded(e:Event):void
		{
			var ah:Animationhost = (new BaseModel((e.target as URLLoader).data)).animationhost;
			trace("ah is:"+ah);
			for each(var am:Animation in ah.animation)
			{
				AnimationDictionary[am.name] = am;
				if(am.texname && bitmaps.indexOf(am.texname) == -1)
				{
					bitmaps.push(am.texname);
				}
			}
			
			bulkloader.addEventListener(BulkProgressEvent.COMPLETE,animationCommplete);
			bulkloader.addEventListener(BulkProgressEvent.PROGRESS,loaderProgress);
			bulkloader.addEventListener("error",bulkloaderError);
			
			var context:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			
			for each(var obs:String in obstacles)
			{
				bulkloader.add(UrlConfig.RESOURCE_ROOT+OBSTACLES_PATH+obs+BitmapSuffix+VersionConfig.getVersionString());
			}
			for each(var textureroot:String in textureRoot)
			{
				bulkloader.add(UrlConfig.RESOURCE_ROOT+TEXTURE_ROOT+textureroot+BitmapSuffix+VersionConfig.getVersionString());
			}
			for each(var swf:String in swfLoaded)
			{
				bulkloader.add(UrlConfig.RESOURCE_ROOT+swf+VersionConfig.getVersionString(),{"context":context});
			}
			
			for each(var xml:String in xmlConfigs)
			{
				bulkloader.add(UrlConfig.RESOURCE_ROOT+XML_PATH+xml+VersionConfig.getVersionString());
			}
			
			this.stage.addChild(loadProgress);
			loadProgress.defaultTextFormat = new TextFormat(null,20,0xffffff,true);
			loadProgress.text = "0%";
			loadProgress.x = 480;
			loadProgress.y = 290;
			loadProgress.mouseEnabled = loadProgress.selectable = false;
			
			bulkloader.start();
		}
		
		protected function bulkloaderError(event:flash.events.ErrorEvent):void
		{
			// TODO Auto-generated method stub
			var item:LoadingItem = event.target as LoadingItem;
			loadProgress.text = "After " + item.numTries + " I am giving up on " + item.url.url;
		}
		
		private var loadProgress:TextField = new TextField();
		
		protected function loaderProgress(event:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
			loadProgress.text = ((int(event.weightPercent*10000))/100).toString()+"%";
		}
		
		protected function animationCommplete(event:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
			for each(var animations:String in bitmaps)
			{
				var c:Class = flash.utils.getDefinitionByName("com.hurrygames.landGrabbers.swc.Animation."+animations) as Class;
				var m:MovieClip = new c();
				var bitmap1:Bitmap = new Bitmap(new BitmapData(m.width,m.height,true,0x0));
				bitmap1.bitmapData.draw(m);
				AnimationBitmaps[animations] = bitmap1;
			}
			
			//现在这里初始化，如果以后有需要，可以在用的时候，再初始化，以降低内存消耗和cpu资源消耗。
			//本身两个资源是unit1_fast_zj0和unit1_fast_zj0_t
			//在这里转换成 unit1_fast_zj0,unit2_fast_zj0,unit3_fast_zj0,unit4_fast_zj0
			for each(var armyAnima:String in armyAnims)
			{
				//目前只有这一个种族，以后可能是4个
				for(var zhongzhu:int = 0;zhongzhu<=0;zhongzhu++)
				{
					//目前是四个势力，中立势力不需要初始化兵
					for(var shili:int = 1;shili<=4;shili++)
					{
						var aimi:String = armyAnima;
						aimi += ("_zj"+zhongzhu.toString());
						var c1:Class = flash.utils.getDefinitionByName("com.hurrygames.landGrabbers.swc.Animation."+aimi) as Class;
						var m2:MovieClip = new c1();
						var ct:Class = flash.utils.getDefinitionByName("com.hurrygames.landGrabbers.swc.Animation."+aimi+"_t") as Class;
						var m1:MovieClip = new ct();
						m1.filters = [fils[(shili-1)]];
						m1.blendMode = BlendMode.MULTIPLY;
						var m3:MovieClip = new ct();
						m2.addChild(m3);
						m2.addChild(m1);
						var bitmap2:Bitmap = new Bitmap(new BitmapData(m2.width,m2.height,true,0x0));
						bitmap2.bitmapData.draw(m2);
						//此处变成uinit2_fast_zj0;
						aimi = aimi.replace("1",shili.toString());
						AnimationBitmaps[aimi] = bitmap2;
						
//						if(shili == 2)
//						{
//							this.addChild(bitmap2);
//							return;
//						}
					}
				}
			}
			
			for each(var obs:String in obstacles)
			{
				var image:ImageItem = bulkloader.get(UrlConfig.RESOURCE_ROOT+OBSTACLES_PATH+obs+BitmapSuffix+VersionConfig.getVersionString()) as ImageItem;
				AnimationBitmaps[obs] = image.content;
			}
			for each(var textureroot:String in textureRoot)
			{
				var image1:ImageItem = bulkloader.get(UrlConfig.RESOURCE_ROOT+TEXTURE_ROOT+textureroot+BitmapSuffix+VersionConfig.getVersionString()) as ImageItem;
				AnimationBitmaps[textureroot] = image1.content;
			}
			loadProgress.parent.removeChild(loadProgress);
			if(_callBack != null)
			{
				_callBack.apply();
			}
		}
		
		private function loadFinished():void
		{
			// TODO Auto Generated method stub
			var configManager:Class = flash.utils.getDefinitionByName("com.hurrygames.grabber.managers.ConfigManager") as Class;
			configManager.instance.AnimationBitmaps = AnimationBitmaps;
			configManager.instance.AnimationDictionary = AnimationDictionary;
			
			var mainApp:ImageItem = bulkloader.get(UrlConfig.RESOURCE_ROOT+"LandGrabbers.swf"+VersionConfig.getVersionString()) as ImageItem;
			if(mainApp.isSWF())
			{
				this.addChild(mainApp.content);
			}
		}
	}
} 
