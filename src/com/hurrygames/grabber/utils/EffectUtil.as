package com.hurrygames.grabber.utils
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;
	
	/**
	 * Project : seafaring
	 * EffectUtil
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class EffectUtil
	{
		public static const flashLastTime:Number = 0.2;
		
		public function EffectUtil()
		{
		}
		
		/**
		 * 闪动一个显示对象，同时改变另一个文本的颜色。如果有的话。 
		 * @param displayObject
		 * @param times
		 * @param textField
		 * @param color
		 * 
		 */		
		public static function FlashDisplayObject(displayObject:DisplayObject,times:int=2,textField:TextField=null,color:uint=0xff0000,finisheCallback:Function=null):void
		{
			var oldTF:TextFormat;
			if(textField != null)
			{
				oldTF = textField.getTextFormat();
				var newTF:TextFormat = textField.getTextFormat();
				newTF.color = color;
				textField.setTextFormat(newTF);
				textField.defaultTextFormat = newTF;
			}
			flash(displayObject,function():void
			{
				if(textField != null)
				{
					textField.setTextFormat(oldTF);
					textField.defaultTextFormat = oldTF;
				}
				if(finisheCallback != null)
				{
					finisheCallback();
				}
			},0,times);
		}
		
		
		/**
		 * 闪动的递归函数。 
		 * @param target
		 * @param finishCallBack
		 * @param time
		 * @param totalTime
		 * 
		 */		
		private static function flash(target:DisplayObject,finishCallBack:Function=null,time:int = 0,totalTime:int = 2):void
		{
			TweenLite.to(target,flashLastTime,{alpha:0.5,onComplete:function():void{
				TweenLite.to(target,flashLastTime,{alpha:1,onComplete:function():void
				{
					time++;
					if(time<totalTime)
					{
						flash(target,finishCallBack,time,totalTime);
					}else
					{
						if(finishCallBack != null)
						{
							finishCallBack();
						}
					}
				}
				});
			}
			});
		}
		
		/**
		 * 灰掉的对象的参数 
		 */		
		private static var grayMap:Dictionary = new Dictionary(true);
		
		
		/**
		 * 把一个显示对象变成灰色。还可以恢复。包括滤镜的恢复。 
		 * @param dis
		 * @param isGray
		 * 
		 */		
		public static function GrayOneDisplayObject(dis:DisplayObject,isGray:Boolean=true):void
		{
			var param:Object;
			
			if (isGray)
			{
				if (grayMap[dis])
					return;
				
				var greyfilter:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
				
				param = {};
				param['filter'] = dis.filters;
				grayMap[dis] = param;
				
				dis.filters = [greyfilter];
				
			}else {
				param = grayMap[dis];
				if ( param == null)
					return;
				
				dis.filters = param['filter'];
				
				delete grayMap[dis];
			}
		}
		
		/**
		 * 播放切换界面过渡效果   
		 * @param parent	父对象
		 * @param type		过渡效果类型
		 * @param w
		 * @param h
		 * @param x		
		 * @param y
		 * 
		 */				
		public static function showSwitchViewEffect(parent:DisplayObjectContainer,w:Number =0, h:Number =0, color:uint = 0x000000, x:Number = 0, y:Number = 0):void {
			var effect:Sprite = new Sprite();
			
			effect.graphics.beginFill(color);
			effect.graphics.drawRect(x,y,w,h);
			effect.graphics.endFill();
			
			parent.addChild(effect);
			
			TweenLite.to(effect,1,{alpha:0});
			TweenLite.delayedCall(1,function():void {
				parent.removeChild(effect);
				effect = null;
			});
		}
	}
} 
