package com.ivequest 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	/**
	 * The title screen of the game. Any key or touch will begin the game.
	 * @author Liam Westby
	 */
	public class TitleLevel extends GameLevel 
	{
		private var pressAnyKey:Sprite;
		private var ticks:Number;
		private var textVisible:Boolean;
		
		public function TitleLevel() 
		{
			super(null, null);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			background = new Image(AssetManager.getTexture("TitleImage"));
			addChild(background);
			
			ticks = 0;
			
			entities = new Vector.<GameEntity>();
			
			pressAnyKey = new Sprite();
			var pressAnyKeyText:TextField = new TextField(350, 50, "Press Any Key", "Arial", 36, 0x0084ff, false);
			pressAnyKeyText.hAlign = HAlign.CENTER;
			pressAnyKey.x = 60;
			pressAnyKey.y = 300;
			
			pressAnyKey.addChild(pressAnyKeyText);
			addChild(pressAnyKey);
			
			textVisible = true;
		}
		
		public override function tick():void
		{
			super.tick();
			ticks = (ticks + 1) % 22;
			if (ticks == 0)
			{
				textVisible = !textVisible;
				pressAnyKey.visible = textVisible;
			}
			
			
		}
		
	}

}