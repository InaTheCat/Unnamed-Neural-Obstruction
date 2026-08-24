package utils;

import backend.system.ANSI;
import haxe.Json;
import openfl.utils.Assets;

using StringTools;

typedef PlayMusicSettings =
{
	@:optional var bpm:Null<Float>;

	/**
	 * If u wanna force to play the exact same music thats
	 * actually playing in other part or in the same state,
	 * set it as `true` to force it to play
	**/
	@:optional var forcePlay:Null<Bool>;

	@:optional var fadeIn:Null<Bool>;

	/**
	 * This only works and take effect if the `loop` is false
	 * and the music is more than 3 seconds long
	**/
	@:optional var fadeOut:Null<Bool>;
}

// whats 9 + 10

class CoolUtil {
	public static var playingMusic(default, null):Bool = false;

	private static var startingFadeOut:Bool = false;
	private static var lastMusic:String = '';

    /**
	 * Self descreptive, but it parses a json and returns a json...
	 * @return a full ass json gng (if it doesnt exists... well, returns null)
	**/
	public static function parseJson(path:String):Null<Dynamic>
	{
		if (!Paths.exists('$path.json'))
		{
			Logs.send('JSON not found. [$path]', {type: Error});
            return null;
        }

		var json:String = Assets.getText(Paths.json('$path'));
        return Json.parse(json);

        // the word json was mentioned 8 + 1 times here btw
	}

	public static function playMusic(path:String = 'freakyMenu', volume:Float = 1, loop:Bool = true, settings:PlayMusicSettings):Void
	{
		var forcePlay:Bool = settings.forcePlay ?? false;
		var bpm:Float = path == 'freakyMenu' ? 102 : (settings.bpm ?? 100);

		var fadeIn:Bool = settings.fadeIn ?? false;
		var fadeOut:Bool = settings.fadeOut ?? false;

		if (lastMusic == path.toLowerCase() && !forcePlay)
		{
			Logs.send('$path is actually playing atm [If you want to skip and for some reason replay the exact same song, use last var in the function, "${ANSI.coloredType('forcePlay', 0xFF0000FF)}"]',
				{
					type: SourceInfo,
					overrideShooterText: '$path is actually playing atm'
				});
			// bigass Log

			return;
		}

		FlxG.sound.playMusic(Paths.music(path), fadeIn ? 0 : volume, loop);

		FlxG.sound?.music.fadeIn(1, 0, volume);

		if (!loop && FlxG.sound?.music?.length >= 3000)
			if (FlxG.sound?.music?.length >= FlxG.sound?.music?.length - 1000 && startingFadeOut)
			{
				startingFadeOut = true;
				FlxG.sound?.music?.fadeOut(1, 0, (_:FlxTween) -> lastMusic = '');
			}

		Conductor.changeBpm(bpm);

		lastMusic = path.toLowerCase();

		return;
	}

    // 21
	public static function sliceFromLine(text:String):Array<String>
	{
		if (text.trim() == '')
			return [''];

		return text.split('\n');
	}

	public static inline function zeros(str:String, amount:Int):String
	{
		while (str.length < amount)
			str = '0${str}';

		return str;
	}

	public static inline function lerp(org:Float, dest:Float, ratio:Float):Float
		return FlxMath.lerp(org, dest, fpsBasedRatio(ratio));

	public static inline function fpsBasedRatio(ratio:Float, ?delta:Null<Float>):Float
		return 1.0 - Math.pow(1.0 - ratio, (delta == null ? FlxG.elapsed : delta) * 60);
}

// you stupid