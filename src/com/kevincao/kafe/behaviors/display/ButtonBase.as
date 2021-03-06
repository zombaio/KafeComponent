package com.kevincao.kafe.behaviors.display
{
	import flash.external.ExternalInterface;

	import com.kevincao.kafe.events.KafeEvent;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;

	[Event(name="buttonDown", type="com.kevincao.kafe.events.KafeEvent")]

	/**
	 * @author Kevin Cao
	 */
	public class ButtonBase extends MovieClipSkinBehavior implements IButton
	{

		public static var PRESS_TIME : Number = 500;
		public static var REPEAT_INTERVAL : Number = 35;

		protected var _enabled : Boolean = false;
		protected var _isRollOver : Boolean = false;
		protected var _isMouseDown : Boolean = false;
		protected var _autoRepeat : Boolean = false;

		protected var _href : String;
		protected var _window : String;

		private var pressTimer : Timer;

		public function get enabled() : Boolean
		{
			return _enabled;
		}

		public function set enabled(value : Boolean) : void
		{
			if (_enabled == value) return;

			_enabled = value;

			_skin.buttonMode = _enabled;
			_skin.mouseEnabled = _enabled;

			invalidate();
		}

		public function get href() : String
		{
			return _href;
		}

		public function set href(value : String) : void
		{
			_href = value;
		}

		public function get window() : String
		{
			return _window;
		}

		public function set window(value : String) : void
		{
			_window = value;
		}

		public function get autoRepeat() : Boolean
		{
			return _autoRepeat;
		}

		public function set autoRepeat(value : Boolean) : void
		{
			_autoRepeat = value;
		}


		/**
		 * 
		 */
		public function ButtonBase(target : MovieClip)
		{
			super(target);

			pressTimer = new Timer(1, 0);
			pressTimer.addEventListener(TimerEvent.TIMER, tick, false, 0, true);

			enabled = true;
		}

		// ----------------------------------
		// override
		// ----------------------------------

		override protected function initSkin() : void
		{
			super.initSkin();

			_skin.mouseChildren = false;
			_skin.stop();

			setupEventListeners();
		}


		// ----------------------------------
		// handlers
		// ----------------------------------

		private function setupEventListeners(b : Boolean = true) : void
		{
			if (b)
			{
				_skin.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
				_skin.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
				_skin.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
				_skin.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			}
			else
			{
				_skin.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				_skin.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				_skin.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				_skin.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}

		protected function clickHandler(event : MouseEvent) : void
		{
			goto();
		}

		protected function rollOverHandler(event : MouseEvent) : void
		{
			_isRollOver = true;
		}

		protected function rollOutHandler(event : MouseEvent) : void
		{
			_isRollOver = false;
		}

		protected function mouseDownHandler(event : MouseEvent) : void
		{
			_isMouseDown = true;
			startPress();
			_skin.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}

		protected function mouseUpHandler(event : MouseEvent) : void
		{
			_isMouseDown = false;
			endPress();
			_skin.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		protected function startPress() : void
		{
			if (_autoRepeat)
			{
				pressTimer.delay = PRESS_TIME;
				pressTimer.start();
			}
			dispatchEvent(new KafeEvent(KafeEvent.BUTTON_DOWN, true));
		}

		internal function endPress() : void
		{
			pressTimer.reset();
		}

		private function tick(event : TimerEvent) : void
		{
			if (!autoRepeat)
			{
				endPress();
				return;
			}
			if (pressTimer.currentCount == 1)
			{
				pressTimer.delay = REPEAT_INTERVAL;
			}
			dispatchEvent(new KafeEvent(KafeEvent.BUTTON_DOWN, true));
		}

		// ----------------------------------
		// public functions
		// ----------------------------------

		override public function destroy() : void
		{
			_skin.stop();
			_skin.buttonMode = false;
			_skin.mouseEnabled = false;
			if (_skin.stage)
			{
				_skin.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
			setupEventListeners(false);

			pressTimer.stop();
			pressTimer.removeEventListener(TimerEvent.TIMER, tick);
			pressTimer = null;

			super.destroy();
		}

		public function goto() : void
		{
			if (_href && _href != "")
			{
				if (_href.indexOf("javascript:") != -1)
				{
					if (ExternalInterface.available)
					{
						try
						{
							ExternalInterface.call(_href);
						}
						catch(error : Error)
						{
							trace(this, error);
						}

					}
				}
				else
				{
					navigateToURL(new URLRequest(_href), _window || "_self");
				}
			}
		}

		// ----------------------------------
		// frame scripts
		// ----------------------------------

		protected function frameStop() : void
		{
			_skin.stop();
		}
	}
}
