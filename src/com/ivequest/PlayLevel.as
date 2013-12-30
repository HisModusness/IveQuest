package com.ivequest 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import flash.media.Sound;
	/**
	 * Superclass of playable levels. It does almost all the work, the only thing the subclasses define is the amount of enemies to kill.
	 * Could easily be changed to allow subclasses to specify many properties such as speed of enemies, speed of player movement, and amount of lives.
	 * @author Liam Westby
	 */
	public class PlayLevel extends GameLevel 
	{
		protected var ticks:Number;
		
		protected var projectileTargetX:int;
		protected var projectileTargetY:int;
		
		protected var firing:Boolean = false;
		protected var playerEntity:PlayerEntity;
		protected var projectile:ProjectileEntity;
		protected var projectiles:Vector.<ProjectileEntity>;
		
		protected var goalPoints:int;
		protected var pointLabel:Sprite;
		protected var pointText:TextField;
		
		protected var healthLabel:Sprite;
		protected var healthText:TextField;
		
		protected var blackScreen:Sprite;
		protected var fadingOut:Boolean;
		
		public function PlayLevel(points:int) 
		{
			goalPoints = points;
			super("TileSet2", new Camera(600, 600, 800, 600, 64));
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			entities = new Vector.<GameEntity>();
			
			var player:PlayerEntity = new PlayerEntity();
			playerEntity = player;
			//addChild(player);
			entities.push(player);
			
			blackScreen = new Sprite();
			blackScreen.addChild(new Quad(stageWidth, stageHeight, 0));
			addChild(blackScreen);
			
			fadingOut = false;
			
			projectiles = new Vector.<ProjectileEntity>(10, true);
			for (var i:int = 0; i < projectiles.length; i++)
			{
				projectiles[i] = new ProjectileEntity();
				projectiles[i].visible = false;
				entities.push(projectiles[i]);
				//addChild(projectiles[i]);
			}
			
			pointLabel = new Sprite();
			pointLabel.addChild(new Quad(100, 25, 0x0));
			
			pointText =  new TextField(100, 25, "0/" + goalPoints, "Verdana", 14, 0xFFFFFF);
			pointLabel.addChild(pointText);
			
			pointLabel.x = 0;
			pointLabel.y = VIEW_HEIGHT - pointLabel.height;
			
			addChild(pointLabel);
			
			healthLabel = new Sprite();
			healthLabel.addChild(new Quad(100, 25, 0));
			
			healthText = new TextField(100, 25, "Lives: " + playerEntity.getHealth(), "Verdana", 14, 0xFFFFFF);
			healthLabel.addChild(healthText);
			
			healthLabel.x = VIEW_WIDTH - healthLabel.width;
			healthLabel.y = VIEW_HEIGHT - healthLabel.height;
			
			addChild(healthLabel);
			
			ticks = 0;
		}
		
		public override function keyPressed(event:KeyboardEvent):void
		{
			if (event.charCode == "w".charCodeAt(0) || event.charCode == "a".charCodeAt(0) || event.charCode == "s".charCodeAt(0) || event.charCode == "d".charCodeAt(0))
			{
				playerEntity.keyPressed(event);
			}
			
		}
		
		public override function keyReleased(event:KeyboardEvent):void
		{
			if (event.charCode == "w".charCodeAt(0) || event.charCode == "a".charCodeAt(0) || event.charCode == "s".charCodeAt(0) || event.charCode == "d".charCodeAt(0)) 
			{
				playerEntity.keyReleased(event);
			}
		}
		
		public override function handleTouch(touch:Touch):void
		{
			if (touch == null) return;
			var touchPoint:Point = screenToWorld(new Point(touch.globalX, touch.globalY));
			if (touch.phase == TouchPhase.BEGAN)
			{
				
				projectileTargetX = touchPoint.x;
				projectileTargetY = touchPoint.y;
				firing = true;
			}
			else if (touch.phase == TouchPhase.MOVED)
			{
				projectileTargetX = touchPoint.x;
				projectileTargetY = touchPoint.y;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				firing = false;
			}
		}
		
		public override function tick():void
		{
			if (!fadingOut && blackScreen.alpha > 0)
			{
				blackScreen.alpha -= 0.1;
				return;
			}
			
			if (fadingOut && blackScreen.alpha < 1.0)
			{
				blackScreen.alpha += 0.1;
				return;
			}
			if (blackScreen.alpha == 1.0)
			{
				if (playerEntity.getPoints() == goalPoints) done = true;
				else if (playerEntity.getHealth() == 0) over = true;
				return;
			}
			ticks++;
			
			if (ticks % 20 == 0)
			{
				var nextEnemy:EnemyEntity = new EnemyEntity(playerEntity);
				entities.push(nextEnemy);
				//addChild(nextEnemy);
			}
			if (ticks % 3 == 0 && firing)
			{
				var p:ProjectileEntity = getNextProjectile();
				if (p != null)
				{
					p.setPosition(playerEntity.positionX, playerEntity.positionY);
					var distance:Number = Math.sqrt(Math.pow(playerEntity.positionX - projectileTargetX, 2) + Math.pow(playerEntity.positionY - projectileTargetY, 2));
					p.setVelocity(((projectileTargetX - playerEntity.positionX) / distance) * 30, ((projectileTargetY - playerEntity.positionY) / distance) * 30);
					p.visible = true;
				}
				
			}
			
			camera.setPosition(playerEntity.getWorldPosition());
			
			for (var i:int = 0; i < entities.length; i++)
			{
				if (entities[i].isEnemy() && entities[i].isDead())
				{
					//removeChild(entities[i]);
					entities.splice(i, 1);
					i--;
				}
			}
			
			//trace("tick");
			pointText.text = playerEntity.getPoints() + "/" + goalPoints;
			healthText.text = "Lives: " + playerEntity.getHealth();
			if (playerEntity.getPoints() == goalPoints || playerEntity.getHealth() == 0)
			{
				swapChildrenAt(getChildIndex(blackScreen), numChildren-1);
				fadingOut = true;
			}
			
			super.tick();
			
		}
		
		public function getNextProjectile():ProjectileEntity
		{
			for each (var p:ProjectileEntity in projectiles)
			{
				if (!p.visible) return p;
			}
			return null;
		}
		
	}

}