package states;

import backend.TroubleShooter;
import flixel.FlxG;
import flixel.FlxState;

class LoadState extends FlxState {
    override function create():Void {
        super.create();

        FlxG.plugins.addPlugin(new TroubleShooter());

		FlxG.switchState(() -> new PlayState());
    }
}