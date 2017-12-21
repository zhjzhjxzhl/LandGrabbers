package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.utils.ServerCall;
	import com.hurrygames.grabber.view.WarField;
	import com.hurrygames.swc.MainUI.UISmallAreaSelector;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import gs.TweenLite;
	import gs.easing.Back;
	import gs.easing.Bounce;
	import gs.easing.Sine;
	
	
	/**
	 * Project : LandGrabbers
	 * SmallAreaHelper
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class SmallAreaHelper extends BaseObject
	{
		
		private var _uiSmallArea:UISmallAreaSelector;
		
		private var _currentBuildings:MovieClip;
		
		/**
		 * 小地图弹出来的时候的起始点 
		 */		
		private static const showStartPosition:Array = 
			[
				new Point(310,240),
				new Point(480,480),
				new Point(770,140),
				new Point(910,310),
				new Point(1120,370)
			];
		
		/**
		 * 当前位于第几大关 
		 */		
		private var _currentIndex:int;
		
		/**
		 * 选择的小关第几个。 
		 */		
		private var _currentSmallIndex:int;
		
		public function SmallAreaHelper()
		{
			super();
		}
		
		override protected function destory():void
		{
			// TODO Auto Generated method stub
			this.removeChild(_uiSmallArea);
			_uiSmallArea = null;
		}
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			_uiSmallArea = new UISmallAreaSelector();
			_uiSmallArea.x = (ConfigManager.GAME_WIDTH)/2;
			_uiSmallArea.y = (this.stage.stageHeight/2);
			_uiSmallArea.rotation = 8;
			_uiSmallArea.visible = false;
			this.addChild(_uiSmallArea);
			
			_uiSmallArea.btn_Close.addEventListener(MouseEvent.CLICK,hideSmallArea);
			
			showArea(UserProfile.instance.userProgress.bigAreaIndex);
		}
		
		/**
		 * 要显示的关的索引。0-4 
		 * @param index
		 * 
		 */		
		public function showArea(index:int):void
		{
			if(_currentHLH != null)
			{
				_currentHLH.close();
				_currentHLH = null;
			}
			_currentIndex = index;
			_uiSmallArea.scaleX = _uiSmallArea.scaleY = 1;
			_uiSmallArea.rotation = 8;
			_uiSmallArea.visible = true;
			
			_uiSmallArea.x = (ConfigManager.GAME_WIDTH)/2;
			_uiSmallArea.y = (ConfigManager.GAME_HEIGHT/2);
			
			TweenLite.from(_uiSmallArea,0.7,{x:showStartPosition[index].x,y:showStartPosition[index].y,scaleX:0,scaleY:0,rotation:-30,ease:/*Bounce.easeOut*/Back.easeOut});
			_uiSmallArea.gotoAndStop(index+1);
			
			_uiSmallArea.mc_DesertBuildings.visible = false;
			_uiSmallArea.mc_FjordBuildings.visible = false;
			_uiSmallArea.mc_ForestBuildings.visible = false;
			_uiSmallArea.mc_LaveBuildings.visible = false;
			_uiSmallArea.mc_PrairieBuildings.visible = false;
			
			destorySmallBuildings();
			
			switch(index)
			{
				case 0:
					_uiSmallArea.mc_ForestBuildings.visible = true;
					_currentBuildings = _uiSmallArea.mc_ForestBuildings;
					break;
				case 1:
					_uiSmallArea.mc_DesertBuildings.visible = true;
					_currentBuildings = _uiSmallArea.mc_DesertBuildings;
					break;
				case 2:
					_uiSmallArea.mc_PrairieBuildings.visible = true;
					_currentBuildings = _uiSmallArea.mc_PrairieBuildings;
					break;
				case 3:
					_uiSmallArea.mc_FjordBuildings.visible = true;
					_currentBuildings = _uiSmallArea.mc_FjordBuildings;
					break;
				case 4:
					_uiSmallArea.mc_LaveBuildings.visible = true;
					_currentBuildings = _uiSmallArea.mc_LaveBuildings;
					break;
				default:
					break;
			}
			initSmallBuildings();
		}
		
		private function initSmallBuildings():void
		{
			if(_currentBuildings)
			{
				if(_currentIndex == UserProfile.instance.userProgress.bigAreaIndex)
				{
					for(var i:int = 0;i<9;i++)
					{
						_currentBuildings["mc_City"+i].visible = false;
						_currentBuildings["mc_City"+i].addEventListener(MouseEvent.CLICK,ChoeseOneCity);
						(_currentBuildings["mc_City"+i] as MovieClip).buttonMode = true;
					}
					for(var j:int = 0;j<=UserProfile.instance.userProgress.smallAreaIndex;j++)
					{
						_currentBuildings["mc_City"+j].visible = true;
					}
				}else
				{
					for(var k:int = 0;k<9;k++)
					{
						_currentBuildings["mc_City"+k].visible = true;
						(_currentBuildings["mc_City"+k] as MovieClip).buttonMode = true;
						_currentBuildings["mc_City"+k].addEventListener(MouseEvent.CLICK,ChoeseOneCity);
					}
				}
			}
		}
		
		private function ChoeseOneCity(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			for(var k:int = 0;k<9;k++)
			{
				_currentBuildings["mc_City"+k].gotoAndStop(1);
			}
			var m:MovieClip = e.currentTarget as MovieClip;
			m.gotoAndStop(2);
			trace((e.currentTarget as DisplayObject).name);
			var smallIndex:int = int(m.name.charAt(m.name.length-1));
			_currentSmallIndex = smallIndex;
			
			if(_currentHLH != null)
			{
				_currentHLH.close();
				_currentHLH = null;
			}
			var hlh:HardLevelHelper = new HardLevelHelper(this);
			this.stage.addChild(hlh);
			var p:Point = m.localToGlobal(new Point());
			hlh.x = p.x+m.width/2;
			hlh.y = p.y-(hlh.height+m.height)/2;
			_currentHLH = hlh;
		}
		
		/**
		 * 难度选择器 
		 */		
		private var _currentHLH:HardLevelHelper;
		
		/**
		 * 以某种难度开始游戏，参数是难度。 
		 * @param mode
		 * 
		 */		
		public function startUseHardMode(mode:int):void
		{
			var variable:URLVariables = new URLVariables();
			variable.bigAreaIndex = _currentIndex;
			variable.smallAreaIndex	= _currentSmallIndex;
			variable.hardLevel = mode;
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.START_ONE_LEVEL,function(result:Object):void
			{
				if(result.code == 1)
				{
				}else
				{
					trace("开始某一关失败，先开始吧！");
				}
			},variable);
			
			MainUIController.instance.setMode(MainUIController.FIGHT_UI);	
			
			LandGrabbers.instance.warField = new WarField();
			LandGrabbers.instance.contentLayer.addChild(LandGrabbers.instance.warField);
			LandGrabbers.instance.warField.loadOther(_currentIndex,_currentSmallIndex,(mode-1));
		}
		
		private function destorySmallBuildings():void
		{
			if(_currentBuildings)
			{
				for(var k:int = 0;k<9;k++)
				{
					_currentBuildings["mc_City"+k].visible = true;
					_currentBuildings["mc_City"+k].removeEventListener(MouseEvent.CLICK,ChoeseOneCity);
				}
			}
			if(_currentHLH != null)
			{
				_currentHLH.close();
				_currentHLH = null;
			}
		}
		
		public function hideSmallArea(e:MouseEvent = null):void
		{
			TweenLite.to(_uiSmallArea,0.7,{x:showStartPosition[_currentIndex].x,y:showStartPosition[_currentIndex].y,scaleX:0,scaleY:0,rotation:-180,onComplete:function():void
				{
					_uiSmallArea.visible = false;
				}
			});
			if(_currentHLH != null)
			{
				_currentHLH.close();
				_currentHLH = null;
			}
		}
		
		
	}
} 
