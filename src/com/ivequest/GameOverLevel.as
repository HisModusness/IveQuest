package com.ivequest 
{
	import flash.media.Sound;
	import starling.text.TextField;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.HAlign;
	/**
	 * Level representing the screen shown when the game is lost. After a few seconds, any key will take you to the title screen to try again.
	 * @author Liam Westby
	 */
	public class GameOverLevel extends GameLevel 
	{
		
		public function GameOverLevel() 
		{
			super(null, null);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var gameOverBG:Quad = new Quad(stageWidth, stageHeight, 0);
			var gameOverText:TextField = new TextField(400, 100, "Game Over :(", "Comic Sans MS", 36, 0xFFFFFF);
			gameOverText.hAlign = HAlign.CENTER;
			
			gameOverText.x = VIEW_WIDTH / 2 - gameOverText.width / 2;
			gameOverText.y = VIEW_HEIGHT / 2 - gameOverText.height / 2;
			
			addChild(gameOverBG);
			addChild(gameOverText);
			
			var gameover:Sound = AssetManager.getSound("GameOver");
			gameover.play();
		}
	}

}