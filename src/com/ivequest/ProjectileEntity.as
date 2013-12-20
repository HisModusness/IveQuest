package com.ivequest 
{
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.display.MovieClip;
	/**
	 * Entity representing a projectile. The level maintains a circular buffer of these, so that many can be on screen at once. Go in the direction of the touch.
	 * @author Liam Westby
	 */
	public class ProjectileEntity extends GameEntity 
	{
		private var numTicks:int = 0;
		public function ProjectileEntity() 
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, init);
			
			var sprite:MovieClip = new MovieClip(AssetManager.getTextureAtlas("Ball").getTextures("ball"), 10);
			sprite.play();
			addChild(sprite);
			Starling.juggler.add(sprite);
		}
		
		public function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		public override function tick():void
		{
			if (visible) numTicks++;
			if (numTicks > 60)
			{
				visible = false;
			}
			positionX += velocityX;
			if (positionX < 0) visible = false;
			else if (positionX > stageWidth - width) visible = false;
			
			positionY += velocityY;
			if (positionY < 0) visible = false;
			else if (positionY > stageHeight - height) visible = false;
			
			if (!visible)
			{
				 setVelocity(0, 0);
				 setPosition( -800, -600);
				 numTicks = 0;
			}
		}
		
		public override function isProjectile():Boolean
		{
			return true;
		}
		
		public override function handleCollision(other:GameEntity):void
		{
			if (other.isEnemy() && !other.isExploding())
			{
				visible = false;
			}
		}
		
	}

}