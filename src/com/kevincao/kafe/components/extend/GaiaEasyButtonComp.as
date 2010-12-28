package com.kevincao.kafe.components.extend
{
	import com.kevincao.kafe.components.ButtonBaseComp;
	import com.kevincao.kafe.extend.GaiaEasyButton;
	import com.kevincao.kafe.extend.IGaiaButton;

	import flash.display.MovieClip;

	[IconFile("GaiaEasyButton.png")]

	/**
	 * @author Kevin Cao
	 */
	public class GaiaEasyButtonComp extends ButtonBaseComp
	{

		[Inspectable(defaultValue="", type="String")]

		public function get branch() : String
		{
			return IGaiaButton(behavior).branch;
		}

		public function set branch(value : String) : void
		{
			IGaiaButton(behavior).branch = value;
		}

		public function GaiaEasyButtonComp()
		{
			super(new GaiaEasyButton(MovieClip(parent)));
		}
	}
}
