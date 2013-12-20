package com.ivequest 
{
	import flash.media.Sound;
	import starling.events.Event;
	import starling.display.Image;
	/**
	 * Level representing the loading screen. The Game controller makes it go away automatically.
	 * @author Liam Westby
	 */
	public class LoadingLevel extends GameLevel 
	{
		
		public function LoadingLevel() 
		{
			super(null, null);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			background = new Image(AssetManager.getTexture("LoadingImage"));
			addChild(background);
			
			var chime:Sound = AssetManager.getSound("StartChime");
			chime.play();
		}
		
	}

}