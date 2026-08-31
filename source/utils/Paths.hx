package utils;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFramesCollection;
import openfl.utils.Assets;

using StringTools;

typedef SongVoicesOptions =
{
	?hasBar:Bool,
	?spaced:Bool
}

class Paths {
	public static var savedFrames:Map<String, FlxFramesCollection> = [];

	private static function getPath(path:String, ?type:String = ''):String
	{
		if (!Assets.exists(path))
		{
			if (path.endsWith('.png'))
			{
				Logs.send('$path does\'nt exists,\ngraphic will be replaced with uh,\nHaxe anticrash logo heh', {type: Warning});
				return 'assets/images/logo/logo.png';
			}

			if (path.endsWith('.xml'))
			{
				Logs.send('$path doesn\'t exists,\nxml will be replaced with uh,\nbf xml cuz, uhm, why not', {type: Warning});

				if (!exists('assets/images/characters/bf.xml'))
				{
					Logs.send('$path doesn\'t exists,\nplease, don\'t delete that...', {type: Error});
					return '';
				}

				return 'assets/images/characters/bf.xml';
			}

			if (path.endsWith('.txt'))
			{
				Logs.send('$path doesn\'t exists,\ntext will be replaced to...,\nabsolutely nothing, literally', {type: Warning});
				return '';
			}

			if (path.endsWith('.ogg'))
			{
				Logs.send('$path doesn\'t exists,\nsound will be replaced with uh,\nthe "beep" sound', {type: Warning});
				return 'assets/sounds/beep.ogg';
			}
		}

		return path;
	}

	public static function init():Void
		FlxG.signals.preStateSwitch.add(() -> savedFrames.clear());

	public static inline function image(path:String):String
		return getPath('assets/images/$path.png');

    public static inline function xml(path:String):String
		return getPath('assets/$path.xml');

	public static inline function getSparrowAtlas(path:String):flixel.graphics.frames.FlxFramesCollection
		return FlxAtlasFrames.fromSparrow(image(path), xml('images/$path'));

	public static inline function json(path:String):String
		return getPath('assets/$path.json');

	public static inline function music(path:String):String
		return getPath('assets/music/$path.ogg');

	public static inline function sound(path:String):String
		return getPath('assets/sounds/$path.ogg');

	public static inline function txt(path:String):String
		return getPath('assets/$path.txt');

	public static function font(path:String):String
	{
		// if (!path.endsWith('.ttf') || !path.endsWith('.otf'))
		// {
		// var found:String = 'nothing';
		// var fails:Int = 0;
		//
		// if (Assets.exists('assets/fonts/$path.ttf'))
		// {
		// path += '.ttf';
		// found = 'ttf';
		// }
		// else
		// fails++;
		//
		// if (Assets.exists('assets/fonts/$path.otf'))
		// {
		// path += '.otf';
		// found = 'otf';
		// }
		// else
		// fails++;
		//
		// if (fails == 2)
		// {
		// Logs.send('Font couldn\'t be found or doesn\'t had an expected\nextension, returning null', {type: Error});
		// return null;
		// }
		//
		// Logs.send('Font didn\'n had extension, but the code\nfound a $found file with the same name', {type: Warning});
		// }

		return getPath('assets/fonts/$path');
	}

	public static inline function songJson(songName:String, difficulty:String):String
		return getPath('assets/songs/$songName/chart/$difficulty.json');

	public static inline function songInst(songName:String):String
		return getPath('assets/songs/$songName/song/Inst.ogg');

	public static inline function exists(path:String):Bool
		return Assets.exists('assets/$path');

	/**
	 * @param type Opponent, Player, bf, dad, uhm, ion know, chars??????
	 * 
	 * @param hasBar Well, the thang of `-opponent`, `-dih` and those thangs,
	 * 				 if its `true`, the bar will appear automatically
	**/
	public static function songVoices(songName:String, ?type:String = '', hasBar:Bool = true)
	{
		var prefix:String = '';

		var hasType = type != null && type.trim() != '';
			
		if (hasType)
			prefix = hasBar ? '-$type' : ' $type';

		return getPath('assets/songs/$songName/song/Voices$prefix.ogg');
	}

    public static function getFrames(key:String):FlxFramesCollection {
        if (savedFrames.exists(key)) {
            var frames = savedFrames.get(key);
            if (frames != null && frames.parent != null && frames.parent.bitmap != null && frames.parent.bitmap.readable)
                return frames;
            savedFrames.remove(key);
        }

        var path = image(key);
        var frames = loadFrames(path);
        if (frames != null)
            savedFrames.set(key, frames);
        return frames;
    }

    private static function loadFrames(path:String):FlxFramesCollection {
        var graph:FlxGraphic = FlxG.bitmap.add(path, false, null);
        if (graph == null)
            return null;
        return graph.imageFrame;
	}
}