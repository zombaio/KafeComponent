package com.kevincao.kafe.components
{
	import com.kevincao.kafe.behaviors.display.ISelectableButton;
	import com.kevincao.kafe.behaviors.display.KafeRadioButton;
	import flash.display.MovieClip;


	[IconFile("KafeRadioButton.png")]

	/**
	 * @author Kevin Cao
	 */
	public class KafeRadioButtonComp extends ButtonBaseComp
	{

		[Inspectable(defaultValue=false)]

		public function get selected() : Boolean
		{
			return ISelectableButton(behavior).selected;
		}

		public function set selected(value : Boolean) : void
		{
			ISelectableButton(behavior).selected = value;
		}

		[Inspectable(defaultValue="defaultGroupName")]

		public function get groupName() : String
		{
			return KafeRadioButton(behavior).groupName;
		}

		public function set groupName(value : String) : void
		{
			KafeRadioButton(behavior).groupName = value;
		}

		/**
		 * 
		 */
		public function KafeRadioButtonComp()
		{
			super(new KafeRadioButton(MovieClip(parent)));
		}
	}
}
