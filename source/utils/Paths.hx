package utils;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFramesCollection;

class Paths {
    public static var savedFrames:Map<String, FlxFramesCollection> = [];

	public static function init():Void
		FlxG.signals.preStateSwitch.add(() -> savedFrames.clear());

    public static inline function image(path:String):String 
        return 'assets/images/$path.png';

    public static inline function xml(path:String):String
        return 'assets/images/$path.xml';

    public static inline function getSparrowAtlas(path:String)
        return FlxAtlasFrames.fromSparrow(image(path), xml(path));

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

    public static inline function songJson(songName:String, difficulty:String):String
        return 'assets/songs/$songName/chart/$difficulty.json';
}