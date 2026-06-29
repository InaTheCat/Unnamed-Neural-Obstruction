package backend.game;

class Conductor
{
	public static var songPosition:Float = 0;
	public static var bpm:Float = 100;
	public static var speed:Float = 1;

	public static var curStep:Int = 0;
	public static var curBeat:Int = 0;

	static var lastStep:Int = -1;
	static var lastBeat:Int = -1;

	public static var curDecStep:Float = 0;
	public static var curDecBeat:Float = 0;

	public static var crochet(get, never):Float;
	public static var stepCrochet(get, never):Float;

	static function get_crochet():Float
		return (60 / bpm) * 1000;

	static function get_stepCrochet():Float
		return crochet / 4;

	public static function reset():Void
	{
		songPosition = 0;
		curStep = 0;
		curBeat = 0;
		curDecStep = 0;
		curDecBeat = 0;
	}

	public static function mapSong(?newBpm:Float, ?newSpeed:Float):Void
	{
		if (newBpm != null && newBpm > 0)
			bpm = newBpm;

		if (newSpeed != null && newSpeed > 0)
			speed = newSpeed;
	}

	public static function update(pos:Float):Void
	{
		updatePosition(pos);

		curDecStep = songPosition / stepCrochet;
		curStep = Math.floor(curDecStep);

		curDecBeat = curDecStep / 4;
		curBeat = Math.floor(curDecBeat);
		if (curBeat != lastBeat)
		{
			lastBeat = curBeat;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				state.beatHit(curBeat);
		}

		if (curStep != lastStep)
		{
			lastStep = curStep;

			var state = Std.downcast(FlxG.state, BeatState);

			if (state != null)
				state.beatHit(curStep);
		}
	}

	public static function updatePosition(elapsed:Float):Void
	{
		final music = FlxG.sound.music;

		if (music == null)
			return;

		songPosition += elapsed * 1000;

		if (Math.abs(songPosition - music.time) > 20)
			songPosition = music.time;
	}
}