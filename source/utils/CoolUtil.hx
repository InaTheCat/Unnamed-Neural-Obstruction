package utils;

import backend.system.ANSI;
import flixel.FlxState;
import haxe.Json;
import openfl.utils.Assets;

using StringTools;

typedef PlayMusicSettings =
{
	?bpm:Float,

	/**
	 * If u wanna force to play the exact same music thats
	 * actually playing in other part or in the same state,
	 * set it as `true` to force it to play
	**/
	?forcePlay:Bool,

	?fadeIn:Bool,

	/**
	 * This only works and take effect if the `loop` is false
	 * and the music is more than 3 seconds long
	**/
	?fadeOut:Bool,
}

typedef StateSettings =
{
	?skipIn:Bool,
	?skipOut:Bool
}

// whats 9 + 10

class CoolUtil {
	public static var playingMusic(default, null):Bool = false;

	private static var startingFadeOut:Bool = false;
	private static var lastMusic:String = '';

	private static var musicFadeIn:Null<Bool>;
	private static var musicFadeOut:Null<Bool>;
	private static var musicLoop:Null<Bool>;

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

		musicFadeIn = fadeIn;
		musicFadeOut = fadeOut;
		musicLoop = loop;

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

		if (fadeIn)
			FlxG.sound?.music.fadeIn(1, 0, volume);

		Conductor.changeBpm(bpm);

		lastMusic = path.toLowerCase();

		playingMusic = true;

		if (FlxG.sound?.music != null && !loop)
			FlxG.sound.music.onComplete = () -> playingMusic = false;

		return;
	}

	public static function updateMusic():Void
	{
		if (!musicFadeOut && !musicLoop)
			return;
		if (startingFadeOut)
			return;

		var music = FlxG.sound.music;

		if (music != null && music.length >= 3000 && music.time >= music.length - 1000)
		{
			startingFadeOut = true;
			music.fadeOut(1, 0, (_:FlxTween) ->
			{
				lastMusic = '';
				playingMusic = false;
			});
		}
	}

    // 21
	/**
	 * Some type of switching the state but with settings like skipping the transition when switching in and out
	 *
	 * @param newState
	 * 		u can guess what it is
	 *
	 * @param settings
	 *		same, but settings
	 *
	 * - skipIn
	 * - skipOut
	 * - sharedParams (WIP n unexistent rn heh)
	**/
	public static function switchState(newState:FlxState = null, settings:StateSettings)
	{
		var skipIn:Bool = settings?.skipIn ?? false;
		var skipOut:Bool = settings?.skipOut ?? false;
	}

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