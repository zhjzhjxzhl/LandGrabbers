package com.hurrygames.grabber.IRenders
{
	import com.hurrygames.grabber.core.IComponent;

	public interface ICityRender extends IComponent
	{
		function removeSelected():void;
		function showUnderAttack():void;
	}
}