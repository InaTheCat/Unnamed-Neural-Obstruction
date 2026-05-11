package backend.game;

class Conductor {
    public static var songPosition:Float = 0;
    public static var bpm:Float = 120;

	public static function getBPMFromSeconds(seconds:Float):{songTime:Float, stepCrochet:Float, stepTime:Int} {
		var stepCrochet = (60 / bpm) * 1000 / 4;
		var stepTime = Std.int(seconds / stepCrochet);
		return {songTime: seconds, stepCrochet: stepCrochet, stepTime: stepTime};
    }

    public static function setSongPosition(seconds:Null<Float>):Void {
        if (seconds == null) return;
        songPosition = seconds;
    }
}