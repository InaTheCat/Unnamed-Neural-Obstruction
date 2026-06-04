package utils;

import backend.TroubleShooter;
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
}

// you stupid