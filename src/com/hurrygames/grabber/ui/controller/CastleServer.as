package com.hurrygames.grabber.ui.controller
{
	import com.hurrygames.grabber.managers.UrlConfig;
	import com.hurrygames.grabber.utils.ServerCall;
	import com.hurrygames.grabber.vo.home.CastleCoinGet;
	import com.hurrygames.grabber.vo.home.CastleUpgradeVO;

	public class CastleServer
	{
		private static var _instance:CastleServer;
		
		public static function get instance():CastleServer
		{
			if(_instance == null)
			{
				_instance = new CastleServer();
			}
			return _instance;
		}
		
		public function CastleServer()
		{
		}
		
		/**
		 *收取自己城堡的金币 
		 * @param callBack 接受CastleCoinGet 的参数
		 * 
		 */
		public function getCastleCoin(callBack:Function):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.CASTLE_COLLECT,function(result:Object):void
			{
				if(result.code == 1)
				{
					var castleCoin:CastleCoinGet = new CastleCoinGet(result.data);
					if(callBack != null)
					{
						callBack(castleCoin);
					}
				}
			});
		}
		
		/**
		 *抖金币 
		 * @param callBack 接受一个参数，是掉落的金币数。
		 * 
		 */
		public function shakePeopleCoin(callBack:Function):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.SHAKE_COINS,function(result:Object):void
			{
				if(result.code == 1)
				{
					if(callBack != null)
					{
						callBack(result.data.coin,result.data.nowAllCoin);
					}
				}
			});
		}
		
		/**
		 * 城堡升级  
		 * @param callBack 接受一个CastleUpgradeVO的参数。
		 * 
		 */
		public function upgradeCastle(callBack:Function):void
		{
			ServerCall.instance.httpJson(UrlConfig.GATE_WAY+UrlConfig.UPGRADE_CASTLE,function(result:Object):void
			{
				if(result.code == 1)
				{
					var upvo:CastleUpgradeVO = new CastleUpgradeVO(result.data);
					if(callBack != null)
					{
						callBack(upvo);
					}
				}
			});
		}
	}
}