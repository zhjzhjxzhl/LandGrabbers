package com.hurrygames.grabber.utils
{
	import com.hurrygames.grabber.config.Path_count_node;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * Project : LandGrabbers
	 * Map 此类主要完成带全有向图的寻路问题.
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Map
	{
		private var _nodes:Array;
		
		public function Map()
		{
		}
		
		public function init(nodes:Array):void
		{
			_nodes = nodes;
		}
		
		/**
		 * 计算出所有节点到这个节点的最短路径。 
		 * @param nodeId
		 * 
		 */		
		public function buildPath(nodeId:int,myCitiesNodes:Vector.<Path_count_node>=null):void
		{
			if(_nodes.length <= nodeId)
			{
				return;
			}
			var t:Number = flash.utils.getTimer();
			for each(var pn:Path_count_node in _nodes)
			{
				pn.distance = Number.MAX_VALUE;
				pn.preNode = null;
				pn.isInSource = false;
				pn.isMine = false;
			}
			if(myCitiesNodes != null)
			{
				for each(var myNode:Path_count_node in myCitiesNodes)
				{
					myNode.isMine = true;
				}
			}
			var currentNode:Path_count_node = _nodes[nodeId];
			currentNode.distance = 0;
			s = [currentNode];
			currentNode.isInSource = true;
			
			while(s.length < _nodes.length)
			{
				var npcn:Path_count_node = getTheNearstPathNotInS((myCitiesNodes!=null));
				if(npcn == null)
				{
					break;
				}
				s.push(npcn);
				npcn.isInSource = true;
			}
			s = null;
//			trace("带权有向图的寻路花费的时间为："+(flash.utils.getTimer()-t)+" Ms");
		}
		
		private var s:Array = [];
		
		/**
		 * 此方法在 非S中寻找到离当前S最短的边。如果返回null则说明已经找不到最近的了或者其余的都不可到达。
		 * 目前可以认为此图是非带权图，每个边长度都是1.
		 * @return 
		 * 
		 */		
		private function getTheNearstPathNotInS(useMine:Boolean = false):Path_count_node
		{
			var nearstPathNode:int;
			var nearstPath:Number = Number.MAX_VALUE;
			for each(var node:Path_count_node in s)
			{
				if(node.radius > 15)
				{
					//说明是城市节点
					(!node.isMine) && (node.distance = Number.MAX_VALUE);
				}
				for each(var nid:int in node.edge)
				{
					//此处修改，极大的提高了速度，可以提高3倍左右。
//					if(s.indexOf(_nodes[nid]) != -1)
					if((_nodes[nid] as Path_count_node).isInSource)
					{
						//此节点已经在s中，继续找下一个节点。
						continue;
					}
					//节点不在s中，则计算此节点到s的距离。
					var real:Number = (new Point(node.point.x-(_nodes[nid] as Path_count_node).point.x,node.point.y-(_nodes[nid] as Path_count_node).point.y)).length;
					//此处计算实际距离
					var dis:Number = node.distance + real;
					if(dis < (_nodes[nid] as Path_count_node).distance)
					{
						(_nodes[nid] as Path_count_node).distance = dis;
						(_nodes[nid] as Path_count_node).preNode = node;
					}
					if(nearstPath > (_nodes[nid] as Path_count_node).distance)
					{
						nearstPath = (_nodes[nid] as Path_count_node).distance;
						nearstPathNode = nid;
					}
				}
			}
			if(nearstPath >= Number.MAX_VALUE)
			{
				//剩余的最近的点，和目标点没有任何连接
				return null;
			}
			return (_nodes[nearstPathNode] as Path_count_node);
		}
	}
} 
