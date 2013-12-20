package com.ivequest 
{
	import flash.media.Sound;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.events.KeyboardEvent;
	/**
	 * Entity representing the player. Has a set amount of lives. Moves with WASD.
	 * @author Liam Westby
	 */
	public class PlayerEntity extends GameEntity 
	{
		protected var w:Boolean = false;
		protected var a:Boolean = false;
		protected var s:Boolean = false;
		protected var d:Boolean = false;
		
		protected var points:int = 0;
		
		protected var deathBeep:Sound;
		
		public function PlayerEntity() 
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, init);
			deathBeep = AssetManager.getSound("Beep");
			
			var playerImage:Image = new Image(AssetManager.getTexture("PlayerIcon"));
			addChild(playerImage);
			
			velocityX = 0;
			velocityY = 0;
			
			pivotX = width / 2.0;
			pivotY = height / 2.0;
			
			positionX = 600;
			positionY = 600;
			
			health = 5;
		}
		
		public function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		public override function tick():void
		{
			positionX += velocityX;
			if (positionX < (width/2)) positionX = width/2;
			else if (positionX > stageWidth - (width/2)) positionX = stageWidth - (width/2);
			
			positionY += velocityY;
			if (positionY < (height/2)) positionY = height/2;
			else if (positionY > stageHeight - (height/2)) positionY = stageHeight - (height/2);
		}
		
		public override function isPlayer():Boolean
		{
			return true;
		}
		
		public override function handleCollision(other:GameEntity):void
		{
			if (other.isEnemy() && !other.isExploding() && ! other.isDead())
			{
				health -= 1;
				deathBeep.play();
			}
		}
		
		public function keyPressed(event:KeyboardEvent):void
		{
			if (event.charCode == "w".charCodeAt(0)) 
			{
				velocityY = -5;
				w = true;
			}
			else if (event.charCode == 's'.charCodeAt(0)) 
			{
				velocityY = 5;
				s = true;
			}
			else if (event.charCode == 'a'.charCodeAt(0)) 
			{
				velocityX = -5;
				a = true;
			}
			else if (event.charCode == 'd'.charCodeAt(0)) 
			{
				velocityX = 5;
				d = true;
			}
			
		}
		
		public function keyReleased(event:KeyboardEvent):void
		{
			if (event.charCode == 'w'.charCodeAt(0)) 
			{
				if (s)
				{
					velocityY = 5;
				}
				else
				{
					velocityY = 0;
				}
				w = false;
				
			}
			else if (event.charCode == 's'.charCodeAt(0)) 
			{
				if (w)
				{
					velocityY = -5;
				}
				else
				{
					velocityY = 0;
				}
				s = false;
			}
			else if (event.charCode == 'a'.charCodeAt(0)) 
			{
				if (d)
				{
					velocityX = 5;
				}
				else
				{
					velocityX = 0;
				}
				a = false;
			}
			else if (event.charCode == 'd'.charCodeAt(0)) 
			{
				if (a)
				{
					velocityX = -5;
				}
				else
				{
					velocityX = 0;
				}
				d = false;
			}
		}
		
		public function getPoints():int
		{
			trace("points request")
			return points;
			
		}
		
		public function setPoints(points:int):void
		{
			this.points = points;
		}
		
	}

}