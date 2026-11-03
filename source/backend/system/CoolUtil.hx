package backend.system;

using StringTools;

// whats 9 + 10

class CoolUtil {
    /**
	 * Self descreptive, but it parses a json and returns a json...
	 * @return a full ass json gng (if it doesnt exists... well, returns a dummy)
	**/
	public static function parseJson(path:String):Null<Dynamic>
	{
		if (!Paths.exists('$path.json'))
		{
			Logs.send('JSON not found. [$path]', Error);
            return haxe.Json.parse('"dummy": "nothing"');
        }

        return haxe.Json.parse(Paths.getContent('$path.json'));
	}

	/**
	 * gets an Array with the animations, ONLY one of them
	 *
	 * if the xml has `idle-alt0000, idle-alt0001, idle-alt0002`,
	 * `bopShii0022, bopShii0023, bopShii0024, bopShii0025`and more,
	 * the array will only have `['idle-alt', 'bopShii']`
	 *
	 * @param path
	 *		the path... but only a String
	**/
	public static function getXmlNames(path:String):Array<String>
	{
		if (!Paths.exists('$path.xml'))
		{
			Logs.send('Xml not found. [$path]', Error);
			return [''];
		}

		var raw:String = Paths.getContent(Paths.xml(path));
		var names:Array<String> = [];

		var regex:EReg = ~/<SubTexture\s+name="([^"]+)"/g;
		var frame:EReg = ~/\d{4}$/;

		var pos:Int = 0;

		while (regex.matchSub(raw, pos))
		{
			var name:String = regex.matched(1);

			if (frame.match(name))
				name = name.substr(0, name.length - 4);

			if (!names.contains(name))
				names.push(name);
			var match = regex.matchedPos();
			pos = match.pos + match.len;
		}

		return names;
	}

    // 21

	public static inline function lerp(org:Float, dest:Float, ratio:Float):Float
		return FlxMath.lerp(org, dest, 1.0 - Math.pow(1.0 - ratio, FlxG.elapsed * 60));
}

// you stupid