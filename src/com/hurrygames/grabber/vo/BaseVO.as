package com.hurrygames.grabber.vo
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * Project : gameFramework
	 * BaseVo
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 * 
	 * 一个把普通对象转化为特定数据结构的类。可以支持基本类型，复合类型。
	 * 如果是数组，则需要使用ArrayElementType说明类型。
	 * 如果是Vector，则直接定义即可。
	 */
	public class BaseVO
	{	
		private static var desDic:Dictionary = new Dictionary();
		
		private var des:XML;
		public function BaseVO(o:Object)
		{
			if(o==null)
			{
				return;
			}
			for(var key:String in o)
			{
				try{
					if(o[key] is Array)
					{
						parseArray(o,key);
					}else
					{
						this[key] = o[key];
					}
				}catch(e:ReferenceError)
				{
					trace(flash.utils.getQualifiedClassName(this)+"没有指定的属性："+key);
				}
				catch(e:TypeError)
				{
					des = desDic[flash.utils.getQualifiedClassName(this)] as XML;
					if(des==null)
					{
						trace("建立本类的描述。。");
						des = flash.utils.describeType(this);
						desDic[flash.utils.getQualifiedClassName(this)] = des;
					}
					var name:String = des.variable.(@name==key).@type;
					var c:Class = flash.utils.getDefinitionByName(name) as Class;
					this[key] = new c(o[key]);
				}
				catch(e:Error)
				{
					trace("对象"+flash.utils.getQualifiedClassName(this)+"解析发生了未知的错误。。。。。。。");
				}
			}
		}
		/**
		 *这个函数不能和上面的合并在一起，编译器此处xml 的e4x 语法解析貌似有点问题。 如果再有更多的话，都弄成函数调用吧。
		 * @param o
		 * @param key
		 * 
		 */		
		private function parseArray(o:Object,key:String):void
		{
			des = desDic[flash.utils.getQualifiedClassName(this)] as XML;
			if(des==null)
			{
				trace("建立本类的描述。。");
				des = flash.utils.describeType(this);
				desDic[flash.utils.getQualifiedClassName(this)] = des;
			}
			var arrayTypeC:Class;
			try{
				var arrayType:String = (des.variable.(@name==key).metadata.(@name=="ArrayElementType")[0].arg[0].@value).toString();
				//如果能取到，说明定义的是数组。并且有ArrayElementType的定义。
				arrayTypeC = flash.utils.getDefinitionByName(arrayType) as Class;
				if(this[key]==null)
				{
					this[key] = [];
				}
			}catch(e:Error)
			{
				//否者，此处定义的是vector。需要改变。
				var r:RegExp = /<.+>/;
				var type:String = des.variable.(@name==key).@type;
				var array:Array = type.match(r);
				var str:String = array[0];
				//去除前后的尖括号。
				str = str.slice(1,str.length);
				str = str.slice(0,str.length-1);
				
				var strArray:Array = str.split("::");
				
				arrayTypeC =  flash.utils.getDefinitionByName(strArray.join(".")) as Class;
				if(this[key] == null)
				{
					var vClass:Class = flash.utils.getDefinitionByName(des.variable.(@name==key).@type) as Class;
					this[key] = new vClass();
				}
			}
			for each(var child:Object in o[key])
			{
				this[key].push(new arrayTypeC(child));
			}
		}
	}
} 
