package backend.system;

import flixel.FlxG;
import flixel.sound.FlxSound;

class SFXBank {
    public static var _beep:FlxSound;
    
    private static var started:Bool = false;

    public static function init() {
        if (started) return;

        _beep = FlxG.sound.load('assets/sounds/beep.ogg', 0.75);

        started = true;
    }
}