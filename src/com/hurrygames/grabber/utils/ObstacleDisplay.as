package com.hurrygames.grabber.utils
{
	import com.hurrygames.grabber.config.Obstacle;
	import com.hurrygames.grabber.managers.ConfigManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gs.TweenLite;
	
	public class ObstacleDisplay extends Bitmap
	{
		private var _obs:Obstacle;
		
		public function ObstacleDisplay(obstacle:Obstacle)
		{
			_obs = obstacle;
			this.cacheAsBitmap = true;
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			this.addEventListener(Event.REMOVED_FROM_STAGE,destory);
			
			var s:Shape = new Shape();
			s.graphics.beginBitmapFill((ConfigManager.instance.AnimationBitmaps[_obs.texture] as Bitmap).bitmapData,null,true);
			s.graphics.moveTo(_obs.p0.x,-_obs.p0.y);
			s.graphics.lineTo(_obs.p1.x,-_obs.p1.y);
			s.graphics.lineTo(_obs.p2.x,-_obs.p2.y);
			s.graphics.lineTo(_obs.p3.x,-_obs.p3.y);
			s.graphics.lineTo(_obs.p0.x,-_obs.p0.y);
			s.graphics.endFill();
			this.bitmapData = new BitmapData(_obs.p2.x-_obs.p0.x,-(_obs.p2.y - _obs.p0.y),false,0x0);
			this.bitmapData.draw(s,(new Matrix(1,0,0,1,-_obs.p0.x,_obs.p0.y)));
			this.x = _obs.pos.x+_obs.p0.x;
			this.y = -_obs.pos.y-_obs.p0.y;
			if(_obs.sliding &&( _obs.texture == "water_tile" /*|| _obs.texture == "water_tile_gag" */))
			{
				this.addEventListener(Event.ENTER_FRAME,enter);
				
				xxx = _obs.slide_speed.x/stage.frameRate;
				yyy = _obs.slide_speed.y/stage.frameRate;
			}
		}
		private var xxx:Number = 0;
		private var yyy:Number = 0;
		
		private var xx:Number = 0;
		private var yy:Number = 0;
		
		private function enter(e:Event):void
		{
			xx += xxx;
			yy += yyy;
			
			var aa:int = xx;
			var bb:int = yy;
			var vector:Vector.<uint>;
//			if(Math.abs(aa)<1)
//			{
//				this.x = _obs.pos.x+_obs.p0.x + xx;
//			}else
//			{
//				this.x = _obs.pos.x+_obs.p0.x;
				if(aa>1)
				{
					xx -= aa;
					vector = this.bitmapData.getVector(new Rectangle(this.bitmapData.width-aa,0,aa,this.bitmapData.height));
					this.bitmapData.scroll(aa,0);
					this.bitmapData.setVector((new Rectangle(0,0,aa,this.bitmapData.height)),vector);
				}else if(aa<-1)
				{
					xx -= aa;
					vector = this.bitmapData.getVector(new Rectangle(0,0,-aa,this.bitmapData.height));
					this.bitmapData.scroll(aa,0);
					this.bitmapData.setVector((new Rectangle(this.bitmapData.width+aa,0,-aa,this.bitmapData.height)),vector);
				}
//			}
//			if(Math.abs(bb)<1)
//			{
//				this.y = -_obs.pos.y-_obs.p0.y - yy;
//			}else
//			{
//				this.y = -_obs.pos.y-_obs.p0.y;
				if(bb>1)
				{
					yy -= bb;
					vector = this.bitmapData.getVector(new Rectangle(0,this.bitmapData.height-bb,this.bitmapData.width,bb));
					this.bitmapData.scroll(0,bb);
					this.bitmapData.setVector((new Rectangle(0,0,this.bitmapData.width,bb)),vector);
				}else if(bb<-1)
				{
					yy -= bb;
					vector = this.bitmapData.getVector(new Rectangle(0,0,this.bitmapData.width,-bb));
					this.bitmapData.scroll(0,bb);
					this.bitmapData.setVector((new Rectangle(0,this.bitmapData.height+bb,this.bitmapData.width,-bb)),vector);
				}
//			}
		}
		
		private function destory(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,enter);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,destory);
			this.bitmapData.dispose();
			this.bitmapData = null;
			_obs = null;
		}
	}
}