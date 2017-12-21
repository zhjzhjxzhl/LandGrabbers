package com.hurrygames.grabber.IRenders
{
	import flash.geom.Point;

	public interface ITowerRender extends ICityRender
	{
		function attackOnePosition(position:Point):void;
	}
}