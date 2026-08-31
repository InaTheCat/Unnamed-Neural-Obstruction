package states;

import backend.game.BeatState;

class UNOState extends BeatState
{
	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
	public var troubleShooter:TroubleShooter;

    override public function create() {
        super.create();
		if (camGame == null)
			FlxG.cameras.add(camGame = new FlxCamera());

		if (camHUD == null)
			FlxG.cameras.add(camHUD = new FlxCamera(), false).bgColor = 0x00000000;

		if (troubleShooter == null)
			FlxG.cameras.add(troubleShooter = new TroubleShooter());
	}

	override public function update(elapsed:Float)
	{
        super.update(elapsed);

		if (FlxG.keys.pressed.ALT)
			if (FlxG.keys.justPressed.R)
				FlxG.resetState();

		if (CoolUtil.playingMusic)
		{
			CoolUtil.updateMusic();
		}

		if (FlxG.sound?.music != null || CoolUtil.playingMusic)
			Conductor.update(elapsed);
	}

	override public function beatHit(curBeat:Int):Void {}

	override public function stepHit(curStep:Int):Void {}
}