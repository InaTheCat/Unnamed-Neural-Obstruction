package game;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import sys.FileSystem;
import utils.Paths;

class HealthBar extends FlxSpriteGroup
{
	// var var, bar bar, var bar, bar var
	// bro be saying pure bs
	public var bar:FlxBar = null;

	public var bg:FlxSprite = null;

	public function new(x:Float = 0, y:Float = 0, min:Float = 0, max:Float = 2, type:String = 'healthBar', ?parent:Dynamic, variable:String,
			dir:FlxBarFillDirection = LEFT_TO_RIGHT, border:Bool = false):Void
	{
		super();

		var path:String = FileSystem.exists(Paths.image('game/hud/$type')) ? Paths.image('game/hud/$type') : Paths.image('game/hud/healthBar');

		add(bg = new FlxSprite(x, y).loadGraphic(path));
		add(bar = new FlxBar(x + 4, y + 4, dir, Std.int(bg.width - 8), Std.int(bg.height - 8), parent, variable, min, max, border));
    }

    public function setColors(player:FlxColor = 0xFF000000, opponent:FlxColor = 0xFFFFFFFF) {
		bar.createFilledBar(opponent, player);
    }
}