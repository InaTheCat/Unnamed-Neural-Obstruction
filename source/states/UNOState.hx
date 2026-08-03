package states;

import backend.game.BeatState;
import backend.system.Logs;

class UNOState extends BeatState
{
	public var camGame:FlxCamera = new FlxCamera();
	public var camHUD:FlxCamera = new FlxCamera();
	public var _topCam:FlxCamera = new FlxCamera();

	var shootNum = -1;

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
			shootNum = (shootNum % 9);

			switch (shootNum)
			{
				case 0:
					Logs.send('Shoot test Info $shootNum', {type: 'Info'});
				case 1:
					Logs.send('Shoot test Warning $shootNum', {type: 'Warning'});
				case 2:
					Logs.send('Shoot test Error $shootNum', {type: 'Error'});
				case 3:
					Logs.send('Shoot test None $shootNum', {type: 'None'});
				case 4:
					trace('Shoot test Trace $shootNum');
				case 5:
					Logs.send('Shoot test Source Info $shootNum', {type: 'Source Info'});
				case 6:
					Logs.send('Shoot test PSeScript $shootNum', {type: 'PSeScript'});
				case 7:
					Logs.send('Shoot test PSeWarning $shootNum', {type: 'PSeWarning'});
				case 8:
					Logs.send('Shoot test PSeError $shootNum', {type: 'PSeError'});
			}
		}
    }

	override function beatHit(curBeat:Int):Void {}

	override function stepHit(curStep:Int):Void {}
}