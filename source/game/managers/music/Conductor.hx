package game.managers.music;

import flixel.sound.FlxSound;

class Conductor {
    public static var songPosition:Float = 0;
    public static var bpm(default, set):Float = 100;

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

    static function set_bpm(v:Float):Float
        return v > 0 ? v : 1;

	public static function reset()
	{
		songPosition = 0;
		bpm = 100;

		curSection = 0;
		curStep = 0;
		curBeat = 0;

		curDecSection = 0;
		curDecStep = 0;
		curDecBeat = 0;
	}

    public static function update(pos:Float, music:FlxSound) {
        updatePosition(pos, music);

		curDecStep = songPosition / stepCrochet;
		curStep = Math.floor(curDecStep);

		curDecBeat = curDecStep / 4;
		curBeat = Math.floor(curDecBeat);
		curSection = Math.floor(curStep / 16);

		curSection = Math.floor(curStep / 16);

		if (curSection != _lSection)
		{
			_lSection = curSection;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				state.sectionHit(curSection);
		}

		if (curBeat != _lBeat)
		{
			_lBeat = curBeat;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				state.beatHit(curBeat);
		}

		if (curStep != _lStep)
		{
			_lStep = curStep;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				state.stepHit(curStep);
		}
    }

    public static function updatePosition(pos:Float, music:FlxSound) {
        songPosition += pos * 1000;

        if (Math.abs(songPosition - music.time) > 20)
            songPosition = music.time;
    }
}