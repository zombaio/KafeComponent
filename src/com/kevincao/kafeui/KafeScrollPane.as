package com.kevincao.kafeui 
{
	import com.kevincao.kafe.ScrollBarBase;
	import com.kevincao.kafe.VScrollBar;
	import com.kevincao.kafe.events.ScrollEvent;
	import com.kevincao.kafe.utils.NumberHelper;
	import com.kevincao.kafeui.core.KafeUIBase;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	[IconFile("../../../../footage/KafeScrollPane.png")]

	/**
	 * @author Kevin Cao
	 */
	public class KafeScrollPane extends KafeUIBase 
	{

		public static const AUTO : String = "auto";
		public static const ALWAYS : String = "always";		public static const HIDE : String = "hide";

		protected var vScrollBar : VScrollBar;		protected var hScrollBar : VScrollBar;

		protected var canvas : Sprite;
		protected var sourceInstance : DisplayObject;

		protected var _scrollBar : Object;
		protected var _source : Object;
		protected var _horizontal : String = AUTO;
		protected var _vertical : String = AUTO;
		protected var _roundProp : Boolean = true;
		protected var _hScrollPosition : Number;
		protected var _vScrollPosition : Number;

		[Inspectable(defaultValue="ScrollBarSkin", type="String")]

		public function get scrollBar() : Object 
		{
			return _scrollBar;
		}

		public function set scrollBar(value : Object) : void 
		{
			if(_scrollBar == value) return;
			
			_scrollBar = value;
			invalidateAll();
		}

		[Inspectable(defaultValue="", type="String")]

		public function get source() : Object 
		{
			return _source;
		}

		public function set source(value : Object) : void 
		{
			if(_source == value) return;
			
			_source = value;
			invalidateAll();
		}

		[Inspectable(defaultValue="auto", type="List", enumeration="auto,always,hide")]

		public function get horizontal() : String 
		{
			return _horizontal;
		}

		public function set horizontal(value : String) : void 
		{
			_horizontal = value;
			invalidateAll();
		}

		[Inspectable(defaultValue="auto", type="List", enumeration="auto,always,hide")]

		public function get vertical() : String 
		{
			return _vertical;
		}

		public function set vertical(value : String) : void 
		{
			_vertical = value;
			invalidateAll();
		}

		[Inspectable(defaultValue=true)]

		public function get roundProp() : Boolean
		{
			return _roundProp;
		}

		public function set roundProp(value : Boolean) : void
		{
			_roundProp = value;
		}

		[Inspectable(defaultValue="0", type="Number")]

		/**
		 * 
		 * @return	0~1
		 */
		public function get vScrollPosition() : Number
		{
			return _vScrollPosition;
		}

		/**
		 * 
		 * @param value:	0~1
		 */
		public function set vScrollPosition(value : Number) : void
		{
			_vScrollPosition = value;
			invalidateProp();
		}

		[Inspectable(defaultValue="0", type="Number")]

		/**
		 * 
		 * @return	0~1
		 */
		public function get hScrollPosition() : Number
		{
			return _hScrollPosition;
		}

		/**
		 * 
		 * @param value:	0~1
		 */
		public function set hScrollPosition(value : Number) : void
		{
			_hScrollPosition = value;
			invalidateProp();
		}

		/**
		 * 
		 */
		public function KafeScrollPane()
		{
			super();
		}

		override protected function addChildren() : void 
		{
			if(_source == null || _source == "") return;
			
			canvas = new Sprite();
			addChild(canvas);
			
			sourceInstance = getDisplayObjectInstance(_source);
			sourceInstance.x = sourceInstance.y = 0;
			canvas.addChild(sourceInstance);
			
			if(_vertical == ALWAYS || _vertical == AUTO) 
			{
				vScrollBar = new VScrollBar(getScrollBarSkin(_scrollBar));
				
				addChild(vScrollBar.skin);
			}
			
			if(_horizontal == ALWAYS || _horizontal == AUTO) 
			{
				hScrollBar = new VScrollBar(getScrollBarSkin(_scrollBar));
				
				// rotate 90
				hScrollBar.rotation = 90;
				hScrollBar.scaleY = -1;
				
				addChild(hScrollBar.skin);
			}			
		}

		override protected function removeChildren() : void 
		{
			if(canvas) 
			{
				if(canvas.parent) 
				{
					canvas.parent.removeChild(canvas);
				}
				if(sourceInstance) 
				{
					canvas.removeChild(sourceInstance);
				}
				_vScrollPosition = 0;
				_hScrollPosition = 0;
			}
			
			if(vScrollBar) 
			{
				removeChild(vScrollBar.skin);
				destroyScrollBar(vScrollBar);
				removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
			if(hScrollBar) 
			{
				removeChild(hScrollBar.skin);
				destroyScrollBar(hScrollBar);
			}
		}

		override protected function validateSize() : void 
		{
			canvas.scrollRect = new Rectangle(0, 0, width, height);
			canvas.graphics.clear();
			canvas.graphics.beginFill(0, 0);
			canvas.graphics.drawRect(0, 0, width, height);
			canvas.graphics.endFill();
			
			if(vScrollBar) 
			{
				vScrollBar.visible = true;
				vScrollBar.size = height;
				vScrollBar.x = width;
				vScrollBar.setScrollProperties(height, 0, sourceInstance.height - height);
				vScrollBar.lineScrollSize = height * 0.1;
				
				if(vScrollBar.enabled) 
				{
					vScrollBar.setScrollPosition(NumberHelper.interpolate(_vScrollPosition, vScrollBar.minScrollPosition, vScrollBar.maxScrollPosition));
					vScrollBar.addEventListener(ScrollEvent.SCROLL, vScrollHandler, false, 0, true);
					addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true);
					
//					vScrollBar.setScrollPosition(NumberHelper.interpolate(_vScrollPosition, vScrollBar.minScrollPosition, vScrollBar.maxScrollPosition));
				}
				else 
				{
					vScrollBar.removeEventListener(ScrollEvent.SCROLL, vScrollHandler);
					removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
					if(_vertical == AUTO) 
					{
						vScrollBar.visible = false;
					}
				}
			}
			
			if(hScrollBar) 
			{
				hScrollBar.visible = true;
				hScrollBar.size = width;
				hScrollBar.y = height;
				hScrollBar.setScrollProperties(width, 0, sourceInstance.width - width);
				hScrollBar.lineScrollSize = width * 0.1;
				
				if(hScrollBar.enabled) 
				{
					hScrollBar.setScrollPosition(NumberHelper.interpolate(_hScrollPosition, hScrollBar.minScrollPosition, hScrollBar.maxScrollPosition));
					hScrollBar.addEventListener(ScrollEvent.SCROLL, hScrollHandler, false, 0, true);
					
//					hScrollBar.setScrollPosition(NumberHelper.interpolate(_hScrollPosition, hScrollBar.minScrollPosition, hScrollBar.maxScrollPosition));
				} 
				else 
				{
					hScrollBar.removeEventListener(ScrollEvent.SCROLL, hScrollHandler);
					if(_horizontal == AUTO) 
					{
						hScrollBar.visible = false;
					}
				}
			}

			super.validateSize();
		}

		override protected function validateProp() : void 
		{
			if(vScrollBar)
			{
				vScrollBar.setScrollPosition(NumberHelper.interpolate(_vScrollPosition, vScrollBar.minScrollPosition, vScrollBar.maxScrollPosition));
			}
			if(hScrollBar)
			{
				hScrollBar.setScrollPosition(NumberHelper.interpolate(_hScrollPosition, hScrollBar.minScrollPosition, hScrollBar.maxScrollPosition));
			}
			super.validateProp();
		}

		//----------------------------------
		//  handlers
		//----------------------------------

		protected function mouseWheelHandler(event : MouseEvent) : void 
		{
			vScrollBar.setScrollPosition(vScrollBar.scrollPosition + (event.delta > 0 ? -1 : 1) * vScrollBar.lineScrollSize);
		}

		protected function vScrollHandler(event : ScrollEvent) : void
		{
			sourceInstance.y = _roundProp ? Math.round(-event.position) : -event.position;
			_vScrollPosition = NumberHelper.normalize(event.position, vScrollBar.minScrollPosition, vScrollBar.maxScrollPosition);
		}

		protected function hScrollHandler(event : ScrollEvent) : void
		{
			sourceInstance.x = _roundProp ? Math.round(-event.position) : -event.position;
			_hScrollPosition = NumberHelper.normalize(event.position, hScrollBar.minScrollPosition, hScrollBar.maxScrollPosition);
		}

		//----------------------------------
		//  helpers
		//----------------------------------

		protected function getScrollBarSkin(key : Object) : MovieClip 
		{
			if(key is DisplayObject) 
			{
//				var c : Class = Class(getDefinitionByName(getQualifiedClassName(key)));				var c : Class = Class(key.constructor);
				return MovieClip(new c());
			} 
			else 
			{
				return MovieClip(super.getDisplayObjectInstance(key));
			}
		}

		protected function destroyScrollBar(scrollBar : ScrollBarBase) : void 
		{
			scrollBar.removeEventListener(ScrollEvent.SCROLL, vScrollHandler);
			scrollBar.destroy();
		}

		//----------------------------------
		//  destroy
		//----------------------------------

		override public function destroy() : void 
		{
			if(vScrollBar) 
			{				
				destroyScrollBar(vScrollBar);
				removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				vScrollBar = null;
			}
			if(hScrollBar) 
			{
				destroyScrollBar(hScrollBar);
				hScrollBar = null;
			}
			
			_scrollBar = null;
			_source = null;
			
			sourceInstance = null;
			canvas = null;
			
			super.destroy();
		}
	}
}
