package states;

import backend.game.BeatState;

class UNOState extends BeatState
{
	public var camGame:FlxCamera = new FlxCamera();
	public var camHUD:FlxCamera = new FlxCamera();
	public var _topCam:FlxCamera = new FlxCamera();

    override public function create() {
        super.create();
		FlxG.cameras.add(camGame);
		FlxG.cameras.add(camHUD, false).bgColor = 0x00000000;
		FlxG.cameras.add(_topCam, false).bgColor = 0x00000000;
		TroubleShooter.instance.setCam(_topCam);

	}

	override public function update(elapsed:Float)
	{
        super.update(elapsed);

		if (FlxG.keys.pressed.ALT)
			if (FlxG.keys.justPressed.R)
				FlxG.resetState();

		if (FlxG.sound?.music != null || CoolUtil.playingMusic)
			Conductor.update(elapsed);
	}

	override public function beatHit(curBeat:Int):Void {}

	override public function stepHit(curStep:Int):Void {}
}