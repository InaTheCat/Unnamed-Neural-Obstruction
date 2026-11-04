package game.managers.music;

import flixel.sound.FlxSound;
import haxe.rtti.Meta;

class Conductor {
    public static var songPosition:Float = 0;
	public static var bpm:Float = 100;

    public static var curSection:Int = 0;
    public static var curStep:Int = 0;
    public static var curBeat:Int = 0;

    public static var curDecSection:Float = 0;
    public static var curDecStep:Float = 0;
    public static var curDecBeat:Float = 0;

    private static var _lSection:Int = -1;
    private static var _lStep:Int = -1;
    private static var _lBeat:Int = -1;

    public static var crochet(get, never):Float;
    public static var stepCrochet(get, never):Float;

    static function get_crochet():Float
        return (60 / bpm) * 1000;

    static function get_stepCrochet():Float
        return crochet / 4;

	public static function reset()
	{
		songPosition = 0;
		bpm = 100;

		curSection = 0;
		curStep = 0;
		curBeat = 0;

		_lSection = -1;
		_lStep = -1;
		_lBeat = -1;

		curDecSection = 0;
		curDecStep = 0;
		curDecBeat = 0;
	}

    public static function update(pos:Float, music:FlxSound) {
		if (bpm < 1)
			bpm = 1;

        updatePosition(pos, music);

		curDecStep = songPosition / stepCrochet;
		curStep = Math.floor(curDecStep);

		curDecBeat = curDecStep / 4;
		curBeat = Math.floor(curDecBeat);

		curDecSection = curDecStep / 16;
		curSection = Math.floor(curDecSection);

		if (curSection != _lSection)
		{
			var oldSection = _lSection;
			_lSection = curSection;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				for (i in (oldSection + 1)...(curSection + 1))
					state.sectionHit(i);
		}

		if (curBeat != _lBeat)
		{
			var oldBeat = _lBeat;
			_lBeat = curBeat;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				for (i in (oldBeat + 1)...(curBeat + 1))
					state.beatHit(i);
		}

		if (curStep != _lStep)
		{
			var oldStep = _lStep;
			_lStep = curStep;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				for (i in (oldStep + 1)...(curStep + 1))
					state.stepHit(i);
		}
    }

    public static function updatePosition(pos:Float, music:FlxSound) {
        songPosition += pos * 1000;

        if (Math.abs(songPosition - music.time) > 20)
            songPosition = music.time;
    }
}