package backend.game;

// Shoutout to Riconuts 
// https://github.com/troll-slaiyers/FNF-Troll-Engine/blob/facaa076140d1cff8f60498169b0b6774b7904e7/source/funkin/states/base/MusicBeatState.hx
enum abstract SyncType(String) to String
{
	var PSYCH_1 = 'psych1';
	var LAST_MIX = 'lastMix';
	var LEGACY = 'legacy';
	var DIRECT = 'direct';
	public static function getSync(str:String):SyncType
	{
		switch (str)
		{
			case 'psych1', 'psych_1', 'psych 1', 'psych 1.0': return PSYCH_1;
			case 'legacy': return LEGACY;
			case 'direct': return DIRECT;
			case 'lastmix', 'last_mix', 'last mix': return LAST_MIX;
			default: return LEGACY;
		}
	}
}

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
	public var syncType(get, set):SyncType = SyncType.LAST_MIX;
	private var LM_LAST_POS:Float = 0.0;


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
		/*songPosition += FlxG.elapsed * 1000;

		if (Math.abs(songPosition - pos) > 20)
			songPosition = pos;*/

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

	function updatePosition(pos:Float):Void
	{
		var music = FlxG.sound.music;
		if (music == null) return;
		var elapsedMS:Float = elapsed * 1000;
		var rawTime:Float = music.time;
		#if FLX_PITCH elapsedMS *= music?.pitch; #end
		switch (syncType)
		{
			case SyncType.PSYCH_1:	
				songPosition += elapsedMS;
				songPosition = FlxMath.lerp(rawTime, songPosition, Math.exp(-elapsedMS * 0.005));
				var delta:Float = rawTime - songPosition;
				if (Math.abs(delta) > 1000) songPosition += 1000 * FlxMath.signOf(delta);
			case SyncType.LEGACY:
				songPosition += elapsedMS;
			case SyncType.DIRECT:
				songPosition = rawTime;
			case SyncType.LAST_MIX:
				if (LM_LAST_POS == rawTime) songPosition += elapsedMS;
				else
				{
					if (Math.abs(rawTime - songPosition) >= elapsedMS) songPosition = rawTime;
					else songPosition += elapsedMS;
					LM_LAST_POS = rawTime;
				}
		}
	}
}