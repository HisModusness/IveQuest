package com.ivequest 
{
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.utils.Timer;
	import starling.display.Quad;
	import starling.events.KeyboardEvent;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	/**
	 * The main game. Roughly equivalent to the controller component of MVC. Maintains the state of the game and the game timer. Its tick method does some work, but invokes the tick on the level.
	 * @author Liam Westby
	 */
	public class Game extends Sprite
	{
		private const STATE_LOADING:int = 1;
		private const STATE_TITLE:int = 2;
		private const STATE_PLAY:int = 3;
		private const STATE_PAUSE:int = 4;
		private const STATE_OVER:int = 5;
		private const STATE_WIN:int = 6;
		private var state:int;
		private var levelNumber:int = 1;
		
		private var timer:Timer;
		private var numTicks:Number;
		
		private var pauseSprite:Sprite;
		
		private var currentLevel:GameLevel;
		
		private var bgm:Sound;
		private var bgmChannel:SoundChannel;
		private var bgmPosition:int;
		
		private var tempTicks:int;
		
		public function Game() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bgm = AssetManager.getSound("BGM3");
			
			numTicks = 0;
			
			state = STATE_LOADING;
			
			currentLevel = new LoadingLevel();
			addChild(currentLevel);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			
			stage.addEventListener(TouchEvent.TOUCH, touchDetected);
			
			timer = new Timer(1000 / 30, 0);
			timer.addEventListener(TimerEvent.TIMER, tick);
			timer.start();
		}
		
		private function tick(event:TimerEvent):void
		{
			++numTicks;
			switch(state)
			{
				
				case STATE_LOADING:
					currentLevel.tick();
					if (numTicks >= 90)
					{
						doneLoading();
					}
					break;
				case STATE_TITLE:
					currentLevel.tick();
					break;
				case STATE_PLAY:
					currentLevel.tick();
					if (currentLevel.isDone())
					{
						removeChild(currentLevel);
						switch(levelNumber)
						{
							case 1:
								currentLevel = new Level1();
								levelNumber = 2;
								break;
							case 2:
								currentLevel = new Level2();
								levelNumber = 3;
								break;
							case 3:
								currentLevel = new Level3();
								levelNumber = 4;
								break;
							case 4:
								doWin();
								break;
						}
						addChild(currentLevel);
					}
					else if (currentLevel.isOver())
					{
						doGameOver();
					}
					break;
				case STATE_PAUSE:
					break;
					
				case STATE_OVER:
					tempTicks++;
					break;
					
				case STATE_WIN:
					currentLevel.tick();
					tempTicks++;
					break;
				
			}
		}
		
		private function doneLoading():void
		{
			removeChild(currentLevel);
			
			currentLevel = new TitleLevel();
			addChild(currentLevel);
			
			
			
			state = STATE_TITLE;
		}
		
		private function doneTitle():void
		{
			removeChild(currentLevel);
			
			currentLevel = new Level1();
			levelNumber = 2;
			addChild(currentLevel);
			
			bgmChannel = bgm.play(0, 9999);
			
			state = STATE_PLAY;
		}
		
		private function doPause():void
		{
			state = STATE_PAUSE;
			bgmPosition = bgmChannel.position;
			bgmChannel.stop();
			pauseSprite = new Sprite();
			var pauseText:TextField = new TextField(100, 25, "Paused", "Verdana", 14, 0xFFFFFF);
			pauseSprite.addChild(new Quad(100, 25, 0));
			pauseSprite.addChild(pauseText);
			pauseSprite.x = stage.stageWidth / 2 - (pauseSprite.width / 2);
			pauseSprite.y = stage.stageHeight / 2 - (pauseSprite.height / 2);
			addChild(pauseSprite);
		}
		
		private function donePause():void
		{
			removeChild(pauseSprite);
			pauseSprite = null;
			bgmChannel = bgm.play(bgmPosition);
			state = STATE_PLAY;
		}
		
		private function doGameOver():void
		{
			removeChild(currentLevel);
			bgmChannel.stop();
			
			currentLevel = new GameOverLevel();
			addChild(currentLevel);
			
			state = STATE_OVER;
			tempTicks = 0;
		}
		
		private function doWin():void
		{
			removeChild(currentLevel);
			bgmChannel.stop();
			
			currentLevel = new WinLevel();
			addChild(currentLevel);
			
			state = STATE_WIN;
			tempTicks = 0;
			
		}
		
		private function keyPressed(event:KeyboardEvent):void
		{
			switch(state)
			{
				case STATE_LOADING:
					break;
					
				case STATE_TITLE:
					doneTitle();
					break;
					
				case STATE_PLAY:
					if (event.keyCode == 27)
					{
						doPause();
					}
					currentLevel.keyPressed(event);
					break;
					
				case STATE_PAUSE:
					if (event.keyCode == 27)
					{
						donePause();
					}
					break;
					
				case STATE_OVER:
					if (tempTicks > 90) doneLoading();
					break;
					
				case STATE_WIN:
					if (tempTicks > 150) doneLoading();
					break;
			}
		}
		
		private function keyReleased(event:KeyboardEvent):void
		{
			switch(state)
			{
				case STATE_LOADING:
					break;
					
				case STATE_TITLE:
					break;
					
				case STATE_PLAY:
					currentLevel.keyReleased(event);
					break;
					
				case STATE_PAUSE:
					break;
			}
		}
		
		private function touchDetected(event:TouchEvent):void
		{
			if (event.getTouch(stage) == null) return;
			switch(state)
			{
				case STATE_LOADING:
					break;
					
				case STATE_TITLE:
					if (event.getTouch(stage).phase == TouchPhase.ENDED)
					{
						doneTitle();
					}
					break;
					
				case STATE_PLAY:
					currentLevel.handleTouch(event.getTouch(stage));
					break;
					
				case STATE_PAUSE:
					break;
			}
		}
		
	}

}