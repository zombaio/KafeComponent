package com.kevincao.kafe.components 
{
	import com.kevincao.kafe.behaviors.Behavior;
	import flash.display.Sprite;

	/**
	 * Kafe
	 * 用复合方式构建的组件
	 * @author Kevin Cao
	 */
	public class CompBase extends Sprite 
	{

		private var _component : Behavior;

		public function get component() : Behavior 
		{
			return _component;
		}

		[Inspectable(defaultValue=true, verbose=1)]

		public function get enabled() : Boolean 
		{
			return _component.enabled;
		}

		public function set enabled(value : Boolean) : void 
		{
			_component.enabled = value;
		}

		/**
		 * 
		 */
		public function CompBase(component : Behavior)
		{
			_component = component;
			
			init();
		}

		protected function init() : void
		{
			// remove avatar
			removeChildAt(0);
			
			mouseEnabled = false;
			mouseChildren = false;
			visible = false;
			
			_component.enabled = _component.enabled;
		}

		public function destroy() : void
		{
			_component.destroy();
			_component = null;
		}
	}
}