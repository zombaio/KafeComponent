/*
 * 
 * Copyright (c) 2010 kevincao.com, All Rights Reserved
 * @author		Kevin Cao
 * @email	 	kevin@kevincao.com
 * 
 */
package com.kevincao.kafe.behaviors.display.extend
{
	import com.kevincao.kafe.behaviors.display.IButton;

	/**
	 * @author Kevin Cao
	 */
	public interface IGaiaButton extends IButton
	{
		function get branch() : String;

		function set branch(value : String) : void;
	}
}
