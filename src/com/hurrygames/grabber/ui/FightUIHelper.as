package com.hurrygames.grabber.ui
{
	import com.hurrygames.grabber.entitys.PlayerEntity;
	import com.hurrygames.grabber.entitys.WarzoneEntity;
	import com.hurrygames.grabber.events.CityEvent;
	import com.hurrygames.grabber.events.FightResultEvent;
	import com.hurrygames.grabber.managers.CenterEventDispatcher;
	import com.hurrygames.grabber.managers.ConfigManager;
	import com.hurrygames.grabber.managers.FightTimerController;
	import com.hurrygames.grabber.managers.LoopController;
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.ui.controller.UserInfoController;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.grabber.utils.ServerCall;
	import com.hurrygames.grabber.utils.timer.TimeFormat;
	import com.hurrygames.swc.FightUI.FightMainUI;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	import gs.TweenLite;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	
	/**
	 * Project : LandGrabbers
	 * FightUIHelper
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class FightUIHelper extends BaseObject
	{
		private var _fightUI:FightMainUI;
		
		/**
		 * 势力条的总长度。 
		 */		
		private static const PERCENT_LENGTH:Number = 890;
		
		
		/**
		 * 玩家间实力的对比。只是比较城市的多少.这5个值加起来是1.如果没有此玩家，或者此玩家已经被消灭，则为此项为0.
		 * 按照player id 0,1,2,3,4的顺序。
		 */		
		private var _cityPrecent:Array;
		
		public function FightUIHelper()
		{
			super();
		}
		
		override protected function init():void
		{
			_fightUI = new FightMainUI();
			this.addChild(_fightUI);
			_fightUI.x = (ConfigManager.GAME_WIDTH-_fightUI.width)/2;
			
			_fightUI.btn_pause.addEventListener(MouseEvent.CLICK,pauseGame);
			
			CenterEventDispatcher.instance.addEventListener(CityEvent.SEIZE_ONE_CITY,changeCityPercent);
			
			this.stage.addEventListener(Event.DEACTIVATE,pause);
			this.stage.addEventListener(Event.ACTIVATE,dePause);
			
			for(var i:int = 1;i<=20;i++)
			{
				if(_fightUI.mc_magicUI["mc_magic"+i])
				{
					_fightUI.mc_magicUI["mc_magic"+i].gotoAndStop(1);
					_fightUI.mc_magicUI["mc_magic"+i].addEventListener(MouseEvent.CLICK,useMagic);
				}
			}
//			_fightUI.mc_magicUI.addEventListener(MouseEvent.MOUSE_OVER,showMUI);
//			_fightUI.mc_magicUI.addEventListener(MouseEvent.MOUSE_OUT,hideMagicUI);
//			_fightUI.mc_magicUI.y = 590;
		}
		
//		protected function hideMagicUI(event:MouseEvent):void
//		{
//			TweenLite.to(_fightUI.mc_magicUI,0.3,{y:590});
//		}
//		
//		protected function showMUI(event:MouseEvent):void
//		{
//			TweenLite.to(_fightUI.mc_magicUI,0.3,{y:532});
//		}		
		
		
		private function useMagic(e:MouseEvent):void
		{
			var magic:MovieClip = e.currentTarget as MovieClip;
		}
		
		
		
		protected function dePause(event:Event):void
		{
			// TODO Auto-generated method stub
			LoopController.instance.stop = false;
			_fightUI.btn_pause.gotoAndStop(1);
		}
		
		private function pause(e:Event):void
		{
			LoopController.instance.stop = true;
			_fightUI.btn_pause.gotoAndStop(2);
		}
		
		override protected function destory():void
		{
//			_fightUI.mc_magicUI.removeEventListener(MouseEvent.MOUSE_OVER,showMUI);
//			_fightUI.mc_magicUI.removeEventListener(MouseEvent.MOUSE_OUT,hideMagicUI);
			
			this.stage.removeEventListener(Event.DEACTIVATE,pause);
			this.stage.removeEventListener(Event.ACTIVATE,dePause);
			CenterEventDispatcher.instance.removeEventListener(CityEvent.SEIZE_ONE_CITY,changeCityPercent);
			_fightUI.btn_pause.removeEventListener(MouseEvent.CLICK,pauseGame);
			this.removeChild(_fightUI);
			_fightUI = null;
		}
		
		/**
		 *城市拥有者发生变化，重新统计实力比例。 
		 * @param e
		 * 
		 */		
		public function changeCityPercent(e:Event=null):void
		{
			//如果是加载后的初始化，则不适用Tween
			var init:Boolean = false;
			if(_cityPrecent == null)
			{
				init = true;
			}
			_cityPrecent = getCityPercent();
			//5跟对比条最终位置
			var targetXs:Array = [0,0,0,0,0];
			for(var i:int = 1;i<5;i++)
			{
				targetXs[i] = targetXs[i-1]+_cityPrecent[i-1]*PERCENT_LENGTH;
			}
			if(!init)
			{
				for(var j:int = 0;j<5;j++)
				{
					TweenLite.to(_fightUI.mc_magicUI.mc_CityPercent["mc_CityPercent"+j],2,{x:targetXs[j],scaleX:_cityPrecent[j]});
				}
			}else
			{
				for(var k:int = 0;k<5;k++)
				{
					_fightUI.mc_magicUI.mc_CityPercent["mc_CityPercent"+k].x = targetXs[k];
					_fightUI.mc_magicUI.mc_CityPercent["mc_CityPercent"+k].scaleX = _cityPrecent[k];
				}
			}
			
			if(_cityPrecent[1] == 1)
			{
				//玩家1获胜了
				CenterEventDispatcher.instance.dispatchEvent(new FightResultEvent(FightResultEvent.FIGHT_PLAYER_WIN));
				
				var variable:URLVariables = new URLVariables();
				variable.passTime = FightTimerController.instance.time;
				variable.bigAreaIndex = LandGrabbers.instance.warField.bigArea;
				variable.smallAreaIndex = LandGrabbers.instance.warField.smallArea;
				ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.PASS_ONE_LEVEL,function(result:Object):void
				{
					if(result.code == 1)
					{
						UserInfoController.instance.getMapInfo();
					}else
					{
						trace("提交战斗胜利，失败了。呵呵");
					}
				},variable);
				///胜利或者失败之后，停止计时.
				FightTimerController.instance.stop();
			}
			if(_cityPrecent[1] == 0)
			{
				//玩家1被消灭了
				CenterEventDispatcher.instance.dispatchEvent(new FightResultEvent(FightResultEvent.FIGHT_PLAYER_LOSE));
				///胜利或者失败之后，停止计时.
				FightTimerController.instance.stop();
			}
		}
		
		/**
		 * 返回0,1,2,3,4号玩家的实力比较。如果没有几号玩家，则为0 
		 * @return 
		 * 
		 */		
		private function getCityPercent():Array
		{
			var arr:Array = [0.25,0.25,0.25,0.25,0.25];
			var warzonE:WarzoneEntity = LandGrabbers.instance.warField.warzone;
			for(var i:int = 0;i<5;i++)
			{
				//0号玩家不计入ai。统计1-4号玩家总共的城市数。
				arr[i] = warzonE.players[i].ownerCities.length;
			}
			var total:int = arr[0]+arr[1]+arr[2]+arr[3]+arr[4];
			for(var j:int = 0;j<5;j++)
			{
				arr[j] = arr[j]/total;
			}
			return arr;
		}
		
		/**
		 * 暂停游戏 
		 * @param e
		 * 
		 */		
		private function pauseGame(e:MouseEvent):void
		{
			LoopController.instance.stop = !LoopController.instance.stop;
		}
	}
} 
