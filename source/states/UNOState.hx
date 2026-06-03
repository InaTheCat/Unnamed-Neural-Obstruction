package states;

import backend.TroubleShooter;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class UNOState extends FlxState {
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
			shoot('Shoot test message ${Std.int(shootNum)}');
		}
    }

    // TroubleShooter
    public inline function shoot(msg:String, ?type:String = 'Info', ?time:Float = 2)
        TroubleShooter.instance.send(msg, type, time);
}