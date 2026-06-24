package;

import backend.CrashLogger;
import backend.FpsMemory;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.*;
import winapi.WindowsCPP;

class Main extends Sprite
{
	public static var game:FlxGame;

	public function new()
	{
		super();
		CrashLogger.init();
		addChild(game = new FlxGame(0, 0, LoadState, 120, 120, true));
		addChild(new FpsMemory(10, 10, 0xFFFFFFFF));
	}
}
