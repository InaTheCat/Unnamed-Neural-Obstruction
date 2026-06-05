package game;

import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class HealthBar extends FlxBar {
    public function new(x:Float = 0, y:Float = 0, width:Int = 200, height:Int = 50, min:Float = 0, max:Float = 2, ?parent:Dynamic, variable:String = "health", dir:FlxBarFillDirection = LEFT_TO_RIGHT, border:Bool = false) {
        super(x, y, dir, width, height, parent, variable, min, max, border);
    }

    public function setColors(player:FlxColor = 0xFF000000, opponent:FlxColor = 0xFFFFFFFF) {
		createFilledBar(opponent, player);
    }
}