package states;

import backend.TroubleShooter;
import flixel.FlxG;
import flixel.FlxState;
import options.Options;

class LoadState extends FlxState {
    override function create():Void {
        super.create();

		Options.init();

        FlxG.plugins.addPlugin(new TroubleShooter());

		FlxG.switchState(() -> new PlayState());
    }
}