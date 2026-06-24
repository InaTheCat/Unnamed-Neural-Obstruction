package states;

import backend.game.BeatState;
import backend.system.Logs;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class UNOState extends BeatState
{
	public var camGame:FlxCamera = new FlxCamera();
	public var camHUD:FlxCamera = new FlxCamera();
	public var _topCam:FlxCamera = new FlxCamera();

	var shootNum = 0;

    override public function create() {
        super.create();
		FlxG.cameras.add(camGame);
		FlxG.cameras.add(camHUD, false).bgColor = 0x00000000;
		FlxG.cameras.add(_topCam, false).bgColor = 0x00000000;
		TroubleShooter.instance.setCam(_topCam);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.pressed.ALT){
            if (FlxG.keys.justPressed.R) FlxG.resetState();
        }
		if (FlxG.keys.justPressed.SPACE)
		{
			shootNum++;
			// shoot('Shoot test message ${Std.int(shootNum)}');
		}
    }

	override function beatHit(curBeat:Int):Void {}

	override function stepHit(curStep:Int):Void {}
}