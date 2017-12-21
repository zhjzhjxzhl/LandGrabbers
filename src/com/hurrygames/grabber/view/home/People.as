package com.hurrygames.grabber.view.home
{
	import com.hurrygames.grabber.managers.LoopController;
	import com.hurrygames.grabber.ui.controller.CastleServer;
	import com.hurrygames.grabber.user.UserProfile;
	import com.hurrygames.grabber.utils.BaseObject;
	import com.hurrygames.landgrabber.swc.People.People1;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import gs.TweenLite;
	
	public class People extends BaseObject
	{
		private var _peopleMc:People1;
		
		/**
		 *人走的速度 
		 */
		private static const SPEED:Number = 2;
		
		/**
		 *ai 改变自己行为的时间限制 
		 */
		private static const AICHANGETIME:Number = 5000;
		/**
		 *当前已经积累的ai改变时间 
		 */
		private var _currentTime:Number = 0;
		
		/**
		 *人物是否因为处于某种特定的动作中，而不参与AI状态的改变 
		 */
		private var _busying:Boolean = false;
		
		/**
		 *人移动的速度 
		 */
		private var speed:Point = new Point(SPEED,0);
		
		public function People()
		{
			super();
			_peopleMc = new People1();
			this.x = 100;
			_peopleMc.gotoAndPlay("walkRight");
			this.addChild(_peopleMc);
		}
		
		private function loop(time:Number):void
		{
			if(_busying)
			{
				return;
			}
			_currentTime += time;
			if(_currentTime >= AICHANGETIME)
			{
				_currentTime = 0;
				var rr:Number = Math.random();
				var ss:Number = 0;
				if(rr>0.5)
				{
					ss = 1;
				}else/* if(rr<0.4)*/
				{
					ss = -1;
				}
				speed = new Point(SPEED*ss);
				adjustAnimationWithSpeed();
			}
		}
		
		private function adjustAnimationWithSpeed():void
		{
			if(speed.x >0)
			{
				_peopleMc.gotoAndPlay("walkRight");
			}else
			{
				_peopleMc.gotoAndPlay("walkLeft");
			}
		}
		
		override protected function destory():void
		{
			super.destory();
			
			LoopController.instance.removeLogicLoop(loop);
			LoopController.instance.removeRenderLoop(renderF);
			this.removeEventListener(MouseEvent.CLICK,douQian);
		}
		
		override protected function init():void
		{
			super.init();
			
			LoopController.instance.addLogicLoop(loop);
			LoopController.instance.addRenderLoop(renderF);
			
			this.addEventListener(MouseEvent.CLICK,douQian);
		}
		
		protected function douQian(event:MouseEvent):void
		{
			if(_busying)
			{
				return;
			}
			_busying = true;
			_peopleMc.gotoAndPlay("douJinBi");
			TweenLite.delayedCall(1,function():void
			{
				_busying = false;
				adjustAnimationWithSpeed();
			});
			CastleServer.instance.shakePeopleCoin(shakeCoin);
		}
		
		private function shakeCoin(coin:int,nowAllCoin:int):void
		{
			trace("获取的金币是:"+coin.toString());
			UserProfile.instance.userData.gold = nowAllCoin;
		}
		
		private function renderF():void
		{
			if(_busying)
			{
				return;
			}
			this.x += speed.x;
			if((x <100 &&(speed.x<0)) || (x>960 &&(speed.x>0)))
			{
				speed.x *= -1;
				adjustAnimationWithSpeed();
			}
		}
		
		public function startJuGong():void
		{
			if(_busying)
			{
				return;
			}
			_busying = true;
			_peopleMc.gotoAndPlay("jugong");
			TweenLite.delayedCall(2,function():void
			{
				_busying = false;
				adjustAnimationWithSpeed();
			});
		}
		
	}
}