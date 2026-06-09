package utils;

import backend.TroubleShooter;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.utils.Assets;

using StringTools;

// whats 9 + 10

class CoolUtil {
    /**
	 * Self descreptive, but it parses a json and returns a json...
	 * @return a full ass json gng (if it doesnt exists... well, returns null)
	**/
    public static function parseJson(path:String):Dynamic {
        if (!Assets.exists('assets/$path.json')) {
            TroubleShooter.instance.send('JSON not found. [$path]', 'Error');
            return null;
        }

        var json:String = Assets.getText('assets/$path.json');
        return Json.parse(json);

        // the word json was mentioned 8 + 1 times here btw
	}
    // 21
	public static inline function lerp(org:Float, dest:Float, ratio:Float):Float
	{
		return FlxMath.lerp(org, dest, fpsBasedRatio(ratio));
	}

	public static inline function fpsBasedRatio(ratio:Float, ?delta:Null<Float>):Float
		return 1.0 - Math.pow(1.0 - ratio, (delta == null ? FlxG.elapsed : delta) * 60);
}

// you stupid