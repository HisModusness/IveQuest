package com.ivequest 
{
	import flash.media.Sound;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	/**
	 * Level representing the screen displayed when you win the game. After a short time, any key will take you back to title.
	 * @author Liam Westby
	 */
	public class WinLevel extends GameLevel 
	{
		private var youWin:Sprite;
		private var ticks:Number;
		private var textVisible:Boolean;
		
		public function WinLevel() 
		{
			super(null, null);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			background = new Image(AssetManager.getTexture("TitleImage"));
			addChild(background);
			
			var youwin:Sound = AssetManager.getSound("YouWin");
			youwin.play();
			
			ticks = 0;
			
			entities = new Vector.<GameEntity>();
			
			youWin = new Sprite();
			var youWinText:TextField = new TextField(350, 150, "You Shipped iOS 7!! Forstall is fired!!", "Arial", 36, 0x0084ff, false);
			youWinText.hAlign = HAlign.CENTER;
			youWin.x = 60;
			youWin.y = 300;
			
			youWin.addChild(youWinText);
			addChild(youWin);
			
			textVisible = true;
		}
		
		public override function tick():void
		{
			super.tick();
			ticks = (ticks + 1) % 22;
			if (ticks == 0)
			{
				textVisible = !textVisible;
				youWin.visible = textVisible;
			}
			
			
		}
	}

}