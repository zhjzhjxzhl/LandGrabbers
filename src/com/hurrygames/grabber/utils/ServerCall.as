package com.hurrygames.grabber.utils
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	/**
	 * Project : LandGrabbers
	 * ServerCallManager
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class ServerCall
	{
		private static var _instance:ServerCall;
		
		public static function get instance():ServerCall
		{
			if(_instance)
			{
				return _instance;
			}else
			{
				_instance = new ServerCall();
			}
			return _instance;
		}
		
		public function ServerCall()
		{
			if (_instance)
				throw new Error("Create HttpData Instance Error");
		}
		
		
		/**
		 * 请求后，派发前的filter 
		 */		
		public static const FILTER_RECV_BEFORE:int = 2;
		/**
		 * 请求后，派发后的filter  
		 */		
		public static const FILTER_RECV_AFTER:int = 3;
		
		/**
		 * 重试次数 
		 */		
		public static var RetryTimes:int = 3;
		
		/**
		 * 记录错误日志的地址 
		 */		
		private static var LOGPATH:String = null;
		
		private static var jsonErrorMessage:String = 'json 解析错误：';
		private static var ioErrorMessage:String = '网络io错误，请检查网络连接!';
		private static var securityErrorMessage:String = '安全问题，请检查crossdomain.xml';
		
		/**
		 * 缓存数据
		 * url => val
		 */
		private var httpCachedDataCache:Object = { };
		
		/**
		 *  等待加载的文件队列 值地址
		 */
		private static var valueQueue:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * httpjson请求时的过滤器 
		 */		
		private static var httpJsonSendFilter:Vector.<Function>;
		/**
		 * httpjson请求后，派发前的filter
		 */		
		private static var httpJsonBeforeFilter:Vector.<Function>;
		/**
		 * httpjson请求后，派发后的filter 
		 */		
		private static var httpJsonAfterFilter:Vector.<Function>;
		
		/**
		 * 设置记录解析错误的地址
		 * 请求为post格式，参数为：Url,Msg
		 *  
		 * @param url
		 * 
		 */		
		public static function setLogUrl(url:String):void
		{
			LOGPATH = url;
		}
		
		/**
		 * 设置错误处理 国际化语言 
		 * @param jsonErrorMessage	json 解析错误：
		 * @param ioErrorMessage	网络io错误，请检查网络连接!
		 * @param securityErrorMessage	安全问题，请检查crossdomain.xml
		 * 
		 */		
		public static function setErrorMessage(jsonErrorMessage:String, ioErrorMessage:String, securityErrorMessage:String):void
		{
			jsonErrorMessage = jsonErrorMessage;
			ioErrorMessage = ioErrorMessage;
			securityErrorMessage = securityErrorMessage;
		}
		
		/**
		 * 添加httpJson的过滤器
		 * 数据发送前的过滤器
		 * 可以修改URLVariables变量
		 *  
		 * @param filter	function，参数为url,method, URLVariables
		 * @param type		过滤器类型
		 * 
		 */		
		public static function addSendFilter(filter:Function):void
		{			
			if (httpJsonSendFilter == null)
				httpJsonSendFilter = new Vector.<Function>();
			
			httpJsonSendFilter.push(filter);
		}
		
		/**
		 * 添加httpJson的过滤器
		 * 数据请求后的过滤器
		 * 如果解析错误，则不调用
		 *  
		 * @param filter	function，参数为 jsonObj
		 * @param type		过滤器类型
		 * 
		 */		
		public static function addRecvFilter(filter:Function, type:int):void
		{
			switch (type)
			{
				case FILTER_RECV_BEFORE:
					if (httpJsonBeforeFilter == null)
						httpJsonBeforeFilter = new Vector.<Function>();
					
					httpJsonBeforeFilter.push(filter);
					break;
				case FILTER_RECV_AFTER:
					if (httpJsonAfterFilter == null)
						httpJsonAfterFilter = new Vector.<Function>();
					
					httpJsonAfterFilter.push(filter);
					break;
			}
		}
		
		/**
		 * 获取http json数据
		 * @param	url	请求地址
		 * @param	callback	请求成功的回调方法，参数为：result
		 * @param	vars	附加的请求变量
		 * @param	progress	进度处理函数 参数为：ProgressEvent
		 * @param	method	请求的方法
		 * @return void
		 */
		public function httpJson( url:String, callback:Function = null, vars:URLVariables = null, progress:Function = null, method:String= null):void
		{
			if (vars == null)
				vars = new URLVariables();
			
			// 过滤器处理
			if (httpJsonSendFilter != null)
			{
				httpJsonSendFilter.every(function (item:Function, index:int,arr:Vector.<Function>):void{
					item(url, method, vars);
				});
			}
			httpData(url, myCallback,vars,progress, method, URLLoaderDataFormat.TEXT);
			
			function myCallback(result:Object):void
			{		
				var obj:Object = { };
				
				if (result is String)
				{
					var stre:String = result as String;
					try {
						obj = com.adobe.serialization.json.JSON.decode(stre);
						
						if (httpJsonBeforeFilter != null)
						{
							httpJsonBeforeFilter.every(function (item:Function, index:int,arr:Vector.<Function>):void{
								item(obj);
							});
						}
					}catch (e:JSONParseError) {
						obj['message'] = jsonErrorMessage + e;
						
						trace ("json 解析错误:", url, vars, result);
						obj['code'] = 0;
						httpLog(url, obj['message']);
					}
					
				}else{
					obj = result;
				}
				
				if (callback != null){
					callback (obj);
					
					if (httpJsonAfterFilter != null)
					{
						httpJsonAfterFilter.every(function (item:Function, index:int,arr:Vector.<Function>):void{
							item(obj);
						});
					}
				}
			}
		}
		
		/**
		 * 获取http Text数据
		 * @param	url	请求地址
		 * @param	callback	请求成功的回调方法，参数为：result
		 * @param	vars	附加的请求变量
		 * @param	progress	进度处理函数	参数为：ProgressEvent
		 * @param	method	请求的方法
		 * @param 	dataFormat	加载数据格式
		 * @retryTimes 是用来做反复调用计数的。
		 * @return void
		 */
		public function httpData( url:String, callback:Function = null, vars:URLVariables = null, progress:Function = null, method:String= null, dataFormat:String="text", retryTimes:int = 0):void
		{	
			var loader:URLLoader = new URLLoader();
			
			// 加载完成
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				trace("HttpLoader finish", url, vars);
				var loaderInfo:URLLoader = URLLoader(e.target);
				
				if (callback != null)
					callback (loaderInfo.data);
			});
			
			// 网络错误
			loader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
				if (retryTimes < RetryTimes)
				{
					retryTimes++;
					httpData(url, callback, vars, progress, method, dataFormat, retryTimes);
					trace("HttpLoader retry", url, retryTimes);
				}else{
					httpLog(url, ioErrorMessage);
					
					if (callback != null)
						callback( { code:0, message:ioErrorMessage } );
					
					trace("HttpLoader", url, "Fail",e);
				}
			} );
			
			// 安全问题
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
				if (callback != null)
					callback({code:0, message:securityErrorMessage});
			} );
			
			// 当地址里面已经有“?”号时，flash不会自动在已有变量后加&
			if (vars != null && vars.toString().length != 0 && url.lastIndexOf("?") != -1 && method != URLRequestMethod.POST)
				url += "&";
			
			var req:URLRequest = new URLRequest(url);
			
			if (method != null)
				req.method = method;
			
			loader.dataFormat = dataFormat;
			
			if (vars != null)
				req.data = vars;
			
			if (progress != null)
				loader.addEventListener(ProgressEvent.PROGRESS, progress);
			
			loader.load(req);
		}
		
		
		/**
		 * 获取http 数据
		 * 带缓存功能
		 * 如果相同的地址，已经请求过了，则直接返回
		 * 
		 * @param	url	请求地址
		 * @param	callback	请求成功的回调方法，参数为：result
		 * @param	vars	附加的请求变量
		 * @param	progress	进度处理函数	参数为：ProgressEvent
		 * @param	method	请求的方法
		 * @param 	dataFormat	加载数据格式
		 * @return void
		 */
		public function httpCachedData( url:String, callback:Function = null, vars:URLVariables = null, progress:Function = null, method:String= null, dataFormat:String="text", retryTimes:int = 0, AddToQueue:Boolean = true):void
		{
			var param:Object = {};
			param['url'] = url;
			param['callback'] = callback;			
			param['vars'] = vars;
			param['progress'] = progress;
			param['method'] = method;
			param['dataFormat'] = dataFormat;
			
			// 如果正在加载，则放入队列
			if (valueQueue.length > 0 && AddToQueue)
			{				
				valueQueue.push(param);
				return;
			}else if(AddToQueue){
				valueQueue.push(param);
			}
			
			// 缓存判断
			if (httpCachedDataCache[url+vars])
			{
				removeAndExecQueue(url, callback, vars, progress, method, dataFormat);
				callback(httpCachedDataCache[url+vars]);
				return;
			}
			
			var loader:URLLoader;
			
			loader= new URLLoader();
			
			// 加载完成
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				trace("httpCachedData finish", url, vars);
				var loaderInfo:URLLoader = URLLoader(e.target);
				
				if (callback != null)
				{
					httpCachedDataCache[url+vars] = loaderInfo.data;
					removeAndExecQueue(url, callback, vars, progress, method, dataFormat);
					
					if (loaderInfo.data is ByteArray)
						callback (loaderInfo.data);
					else
						callback (null);
				}
			});
			
			// 网络错误
			loader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
				if (retryTimes < retryTimes)
				{
					retryTimes++;
					httpCachedData(url, callback, vars, progress, method, dataFormat, retryTimes, false);
					trace("httpCachedData retry", url, retryTimes);
				}else{
					httpLog(url,ioErrorMessage);
					
					if (callback != null){
						removeAndExecQueue(url, callback, vars, progress, method, dataFormat);
						callback( null );
					}
					
					trace("httpCachedData", url, "Fail",e);
				}
			} );
			
			// 安全问题
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
				trace("httpCachedData", url, "SecurityErrorEvent",e);
				if (callback != null){
					removeAndExecQueue(url, callback, vars, progress, method, dataFormat);
					callback(null);
				}
			} );
			
			// 当地址里面已经有“?”号时，flash不会自动在已有变量后加&
			if (vars != null && vars.toString().length != 0 && url.lastIndexOf("?") != -1 && method != URLRequestMethod.POST)
				url += "&";
			
			var req:URLRequest = new URLRequest(url);
			
			if (method != null)
				req.method = method;
			
			loader.dataFormat = dataFormat;
			
			if (vars != null)
				req.data = vars;
			
			if (progress != null)
				loader.addEventListener(ProgressEvent.PROGRESS, progress);
			
			loader.load(req);
		}
		
		// 删除队列并继续执行队列
		private function removeAndExecQueue(url:String, callback:Function = null, vars:URLVariables = null, progress:Function = null, method:String= null, dataFormat:String="text"):void
		{
			var param:Object;
			for(var i:int = 0; i<valueQueue.length; i++)
			{
				param = valueQueue[i];
				if (param.url == url && param.callback==callback && param.vars == vars &&
					param.progress == progress && param.method == method && param.dataFormat == dataFormat)
				{
					valueQueue.splice(i, 1);
					break;
				}
			}
			
			// 继续执行队列
			if (valueQueue.length > 0)
			{
				param = valueQueue[0];
				httpCachedData(param.url, param.callback, param.vars, param.progress, param.method, param.dataFormat,0, false);
			}
		}
		
		/**
		 * 客户端发送错误日志到服务器端
		 * @param	urlqqq
		 * @param	msg
		 */
		public function httpLog( url:String, msg:String):void
		{
			if (LOGPATH == null)
				return;
			
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest();
			req.url = LOGPATH;
			
			loader.addEventListener(Event.COMPLETE, ignoreEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ignoreEvent);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ignoreEvent);
			
			var vars:URLVariables = new URLVariables();
			vars.Url = url;
			vars.Msg = msg;
			
			req.data = vars;
			
			req.method = URLRequestMethod.POST;
			
			loader.load(req);
		}
		
		/**
		 * 忽略事件
		 * @param	e
		 */
		private function ignoreEvent(e:Event):void
		{
			// ignore
		}

	}
} 
