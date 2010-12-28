/*
 * 
 * Copyright (c) 2010 kevincao.com, All Rights Reserved
 * @author		Kevin Cao
 * @email	 	kevin@kevincao.com
 * 
 */
package com.kevincao.kafe.behaviors
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;

	/**
	 * @author Kevin Cao
	 */
	public interface IBehavior extends IEventDispatcher
	{
		function get enabled() : Boolean;

		function set enabled(value : Boolean) : void;

		function get skin() : MovieClip;

		function set skin(skin : MovieClip) : void;

		function destroy() : void;
	}
}
