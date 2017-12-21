package com.hurrygames.grabber.utils
{
	public class ListDataHelper
	{
		/**
		 * 列表帮助类。 
		 * @param arr 原始数据,只能是array或者Vector
		 * @param renderNum	每页显示的个数
		 * 
		 */		
		public function ListDataHelper(arr:Object,renderNum:int)
		{
			if((arr is Array)||(arr is Vector.<*>))
			{
				if(arr is Vector.<*>)
				{
					_datas = [];
					for each(var obj:* in arr)
					{
						_datas.push(obj);
					}
				}else
				{
					_datas = arr as Array;
				}
				(_datas == null)&&(_datas = []);
				_renderNum = renderNum;
			}else
			{
				throw(new Error("ListDataHelper的arr参数只能是Vector或者Array"));
			}
		}

		private var _datas:Array ;
		private var _renderNum:int;
		
		
		private var _currentIndex:int = 0;
		//此处返回的是一个数组，数组的长度等于RenderNumber，刚好够显示在list上。
		
		/**
		 * 数据的总长度 
		 * @return 
		 * 
		 */		
		public function get length():int
		{
			return _datas.length;
		}
		
		/**
		 * 获取下一页数据。 
		 * @param step 向后滚动多少个。一般是一页数据，也就是和renderNumber一样多。
		 * @param selectedFunction 过滤函数，根据此函数确定元素是否在选中集合中。 默认是不做选择。
		 * @param fullEmpty 是否自动填充，当最后不足一页的时候，是否自动向前搜索填满一页。默认是填充
		 * @return 
		 * 
		 */		
		public function rollNext(step:int,selectedFunction:Function=null,fullEmpty:Boolean=true):Array
		{
			if(_datas.length<=_renderNum)
			{
				if(selectedFunction == null)
				{
					return _datas;
				}else
				{
					var a:Array = [];
					for each(var o:Object in _datas)
					{
						if(selectedFunction.call(null,o))
						{
							a.push(o);
						}
					}
					return a;
				}
			}
			var index:int = _currentIndex + step;
			if(fullEmpty&&(index>_datas.length - _renderNum))
			{
				index = _datas.length - _renderNum;
			}
			if(index<0)
			{
				index = 0;
			}
			_currentIndex = index;
			var ra:Array = [];
			var j:int = 0;
			for(var i:int = 0;i<_renderNum;i++)
			{
				if((j+_currentIndex)>=_datas.length)
				{
					break;
				}
				if((selectedFunction!=null)&&(!selectedFunction.call(null,_datas[j+_currentIndex])))
				{
					i--;
					j++;
					continue;
				}
				ra.push(_datas[j+_currentIndex]);
				j++;
			}
			if(fullEmpty)
			{
				if(ra.length<_renderNum)
				{
					while(ra.length<_renderNum)
					{
						_currentIndex --;
						if(_currentIndex<0)
						{
							break;
						}
						if((selectedFunction!=null)&&(selectedFunction.call(null,_datas[_currentIndex])))
						{
							ra.unshift(_datas[_currentIndex]);
						}
					}
				}
			}
			return ra;
		}
		
		/**
		 * 当前的list是否位于最前面的一页。 
		 * @return 
		 * 
		 */		
		public function atBegin():Boolean
		{
			return (_currentIndex == 0);
		}
		
		/**
		 * 当前的list是否位于最后一页。 
		 * @return 
		 * 
		 */		
		public function atEnd():Boolean
		{
			return (_currentIndex >= _datas.length - _renderNum);
		}
		
		/**
		 * list总共有多少页。 
		 * @return 
		 * 
		 */		
		public function get totalPage():int
		{
			return Math.ceil(_datas.length/_renderNum);
		}
		
		/**
		 * list当前位于哪一页。 
		 * @return 
		 * 
		 */		
		public function get currentPage():int
		{
			if(_datas.length == 0)
			{
				return 0;
			}
			return (Math.ceil(_currentIndex/_renderNum)+1);
		}
	}
}