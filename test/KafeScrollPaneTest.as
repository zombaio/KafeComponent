package  
{
	import flash.events.MouseEvent;

	import com.bit101.components.PushButton;
	import com.bit101.components.HBox;
	import com.kevincao.kafeui.*;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author Kevin Cao
	 */

	public class KafeScrollPaneTest extends Sprite 
	{
		private var ksp : KafeScrollPane;

		public function KafeScrollPaneTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//			ksp.setSize(1000, 700);
			//			ksp.source = "content";
			//			addChild(ksp);

			ksp = KafeScrollPane(getChildByName("_ksp"));
			
			var hbox : HBox = new HBox(this, 10, 10);
			new PushButton(hbox, 0, 0, "setSize", clickHandler);
			new PushButton(hbox, 0, 0, "source", clickHandler);
			new PushButton(hbox, 0, 0, "vscroll", clickHandler);
		}

		private function clickHandler(event : MouseEvent) : void 
		{
			switch(event.target.label)
			{
				case "setSize":
					ksp.setSize(120, 120);
					break;
				case "source":
					ksp.source = "content2";
					break;
				case "vscroll":
					ksp.vScrollPosition = .5;
					break;
				case "hscroll":
					ksp.hScrollPosition = 1;
					break;
			}
		}
	}
}