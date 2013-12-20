package com.ivequest 
{
	import starling.display.MovieClip;
	import flash.display3D.textures.Texture;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	/**
	 * Representation of the enemy icons which move around the screen. Enemies choose random destinations and move. Touching them costs you a life.
	 * @author Liam Westby
	 */
	public class EnemyEntity extends GameEntity 
	{
		protected var destinationX:int;
		protected var destinationY:int;
		
		protected var dead:Boolean;
		protected var exploding:Boolean;
		protected var deathTicks:int;
		
		protected var image:Image;
		
		protected var player:PlayerEntity;
		
		public function EnemyEntity(p:PlayerEntity) 
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, init);
			
			player = p;
			
			image = new Image(AssetManager.getIcons()[(int)(Math.random() * 16)])
			addChild(image);
			
			positionX = (int)(Math.random() * (stageWidth - 50)) + 25;
			positionY = (int)(Math.random() * (stageHeight - 50)) + 25;
			
			scaleX = 50.0 / 156;
			scaleY = 50.0 / 156;
			
			destinationX = positionX
			destinationY = positionY
			
			health = 1;
			dead = false;
			exploding = false;
		}
		
		public function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		public override function isEnemy():Boolean
		{
			return true;
		}
		
		public override function isDead():Boolean
		{
			return dead;
		}
		
		public override function isExploding():Boolean
		{
			return exploding;
		}
		
		public override function handleCollision(other:GameEntity):void
		{
			if (other.isProjectile() || other.isPlayer())
			{
				health -= 1;
				if (health == 0)
				{
					setVelocity(0, 0);
					scaleX = 1.0;
					scaleY = 1.0;
					
					exploding = true;
					removeChild(image);
					
					var sprite:MovieClip = new MovieClip(AssetManager.getTextureAtlas("Explosion").getTextures("Explosion"), 10);
					sprite.play();
					addChild(sprite);
					Starling.juggler.add(sprite);
					
					deathTicks = 0;
					
					player.setPoints(player.getPoints() + 1);
				}
			}
		}
		
		public override function tick():void
		{
			super.tick();
			if (!exploding && !dead)
			{
				if (Math.abs(positionX - destinationX) <= 100 && Math.abs(positionY - destinationY) <= 100)
				{
					destinationX = (int)(Math.random() * (stageWidth - 50)) + 25;
					destinationY = (int)(Math.random() * (stageHeight - 50)) + 25;
				
					var distance:Number = Math.sqrt(Math.pow(destinationX - positionX, 2) + Math.pow(destinationY - positionY, 2));
					setVelocity(((destinationX - positionX) / distance) * 10, ((destinationY - positionY) / distance) * 10);
				}
			}
			
			
			if (exploding && !dead)
			{
				deathTicks++;
			}
			if (deathTicks >= 30)
			{
				dead = true;
			}
			
		}
	}

}