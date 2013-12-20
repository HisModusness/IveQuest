package com.ivequest 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	/**
	 * Superclass for every entity in the game. They all have a velocity and some health (although projectiles ignore the latter.)
	 * By virtue of being sprites, they hold the position but the stage dimensions must be saved manually here.
	 * @author Liam Westby
	 */
	public class GameEntity extends Sprite
	{
		protected var velocityX:int;
		protected var velocityY:int;
		
		public var positionX:int;
		public var positionY:int;
		
		protected const TILE_WIDTH:int = 64;
		protected const TILE_HEIGHT:int = 64;
		protected const TILES_WIDE:int = 20;
		protected const TILES_HIGH:int = 20;
		
		protected const stageWidth:int = TILE_WIDTH * TILES_WIDE;
		protected const stageHeight:int = TILE_HEIGHT * TILES_HIGH;
		
		protected var health:int;
		
		public function GameEntity() 
		{
		}
		
		public function tick():void
		{
			positionX += velocityX;
			if (positionX < 0) positionX = 0;
			else if (positionX > stageWidth - width) positionX = stageWidth - width;
			
			positionY += velocityY;
			if (positionY < 0) positionY = 0;
			else if (positionY > stageHeight - height) positionY = stageHeight - height;
		}
		
		public function handleCollision(other:GameEntity):void
		{
			
		}
		
		public function isExploding():Boolean
		{
			return false;
		}
		
		public function isDead():Boolean
		{
			return false;
		}
		
		public function setPosition(x:int, y:int):void
		{
			positionX = x;
			positionY = y;
		}
		
		public function setVelocity(x:int, y:int):void
		{
			velocityX = x;
			velocityY = y;
		}
		
		public function getWorldBounds():Rectangle
		{
			return new Rectangle(positionX, positionY, width, height);
		}
		
		public function getWorldPosition():Point
		{
			return new Point(positionX, positionY);
		}
		
		public function isEnemy():Boolean
		{
			return false;
		}
		
		public function isPlayer():Boolean
		{
			return false;
		}
		
		public function isProjectile():Boolean
		{
			return false;
		}
		
		public function getHealth():int 
		{
			return health;
		}
		
	}

}