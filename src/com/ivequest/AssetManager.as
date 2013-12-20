package com.ivequest 
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * A static class which manages getting assets that have been embedded. Memoizes the objects for memory economy.
	 * @author Liam Westby
	 */
	public class AssetManager 
	{
		[Embed(source = "../../../assets/gfx/loading.png")] private static var LoadingImage:Class;
		[Embed(source = "../../../assets/gfx/ivequest.png")] private static var TitleImage:Class;
		[Embed(source = "../../../assets/gfx/linen.png")] private static var Linen:Class;
		[Embed(source = "../../../assets/gfx/playericon.png")] private static var PlayerIcon:Class;
		
		[Embed(source = "../../../assets/gfx/icons/iBooks.png")] private static var iBooks:Class;
		[Embed(source = "../../../assets/gfx/icons/iPod.png")] private static var iPod:Class;
		[Embed(source = "../../../assets/gfx/icons/iTunes.png")] private static var iTunes:Class;
		[Embed(source = "../../../assets/gfx/icons/Mail.png")] private static var Mail:Class;
		[Embed(source = "../../../assets/gfx/icons/Maps.png")] private static var Maps:Class;
		[Embed(source = "../../../assets/gfx/icons/Music.png")] private static var Music:Class;
		[Embed(source = "../../../assets/gfx/icons/Notes.png")] private static var Notes:Class;
		[Embed(source = "../../../assets/gfx/icons/Photo Booth.png")] private static var PhotoBooth:Class;
		[Embed(source = "../../../assets/gfx/icons/Photos.png")] private static var Photos:Class;
		[Embed(source = "../../../assets/gfx/icons/Safari.png")] private static var Safari:Class;
		[Embed(source = "../../../assets/gfx/icons/Settings.png")] private static var Settings:Class;
		[Embed(source = "../../../assets/gfx/icons/Stocks.png")] private static var Stocks:Class;
		[Embed(source = "../../../assets/gfx/icons/Videos.png")] private static var Videos:Class;
		[Embed(source = "../../../assets/gfx/icons/Voice Recorder.png")] private static var VoiceRecorder:Class;
		[Embed(source = "../../../assets/gfx/icons/Weather.png")] private static var Weather:Class;
		[Embed(source = "../../../assets/gfx/icons/YouTube.png")] private static var YouTube:Class;
		
		[Embed(source = "../../../assets/sfx/chime.mp3")] private static var StartChime:Class;
		[Embed(source = "../../../assets/sfx/bgm.mp3")] private static var BGM:Class;
		[Embed(source = "../../../assets/sfx/bgm2.mp3")] private static var BGM2:Class;
		[Embed(source = "../../../assets/sfx/beep.mp3")] private static var Beep:Class;
		[Embed(source = "../../../assets/sfx/gameover.mp3")] private static var GameOver:Class;
		[Embed(source = "../../../assets/sfx/win.mp3")] private static var YouWin:Class;
		
		[Embed(source = "../../../assets/gfx/tiles/tiles.png")] private static var TileSet:Class;
		[Embed(source = "../../../assets/gfx/tiles/tiles.xml", mimeType = "application/octet-stream")] private static var TileSetXML:Class;
		
		[Embed(source = "../../../assets/gfx/explosion/explosion.png")] private static var Explosion:Class;
		[Embed(source = "../../../assets/gfx/explosion/explosion.xml", mimeType = "application/octet-stream")] private static var ExplosionXML:Class;
		
		[Embed(source = "../../../assets/gfx/ball/ball.png")] private static var Ball:Class;
		[Embed(source = "../../../assets/gfx/ball/ball.xml", mimeType = "application/octet-stream")] private static var BallXML:Class;
		
		private static var textures:Dictionary = new Dictionary();
		private static var sprites:Dictionary = new Dictionary();
		private static var sounds:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture 
		{
			if (textures[name] == undefined)
			{
				textures[name] = Texture.fromBitmap(new AssetManager[name]());
			}
			return textures[name];
		}
		
		public static function getTextureAtlas(name:String):TextureAtlas
		{
			if (sprites[name] == undefined)
			{
				var texture:Texture = Texture.fromBitmap(new AssetManager[name]());
				var xml:XML = XML(new AssetManager[name + "XML"]());
				sprites[name] = new TextureAtlas(texture, xml);
			}
			return sprites[name];
		}
		
		public static function getSound(name:String):Sound
		{
			if (sounds[name] == undefined)
			{
				sounds[name] = new AssetManager[name]() as Sound;
			}
			return sounds[name];
		}
		
		public static function getIcons():Vector.<Texture>
		{
			var icons:Vector.<Texture> = new Vector.<Texture>();
			icons.push(getTexture("iBooks"));
			icons.push(getTexture("iPod"));
			icons.push(getTexture("iTunes"));
			icons.push(getTexture("Mail"));
			icons.push(getTexture("Maps"));
			icons.push(getTexture("Music"));
			icons.push(getTexture("Notes"));
			icons.push(getTexture("PhotoBooth"));
			icons.push(getTexture("Photos"));
			icons.push(getTexture("Safari"));
			icons.push(getTexture("Settings"));
			icons.push(getTexture("Stocks"));
			icons.push(getTexture("Videos"));
			icons.push(getTexture("VoiceRecorder"));
			icons.push(getTexture("Weather"));
			icons.push(getTexture("YouTube"));
			
			return icons;
		}
		
	}

}