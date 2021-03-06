package com.kevincao.kafe.components
{
	import com.kevincao.kafe.behaviors.IBehavior;

	import flash.display.Sprite;

	/**
	 * CompBase
	 * 用复合方式构建的组件
	 * @author Kevin Cao
	 */
	public class CompBase extends Sprite implements IComponent
	{

		private var _behavior : IBehavior;

		public function get behavior() : IBehavior
		{
			return _behavior;
		}

		/**
		 * 
		 */
		public function CompBase(behavior : IBehavior)
		{
			_behavior = behavior;

			init();
		}

		protected function init() : void
		{
			// remove avatar
			removeChildAt(0);

			mouseEnabled = false;
			mouseChildren = false;
			visible = false;
		}

		public function destroy() : void
		{
			_behavior.destroy();
			_behavior = null;
		}
	}
}
