package;

import backend.CrashLogger;
import backend.FpsMemory;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.*;

class Main extends Sprite
{
	public function new()
	{
		super();
		CrashLogger.init();
		addChild(new FlxGame(0, 0, LoadState, 60, 60, true));
		addChild(new FpsMemory(10, 10, 0xFFFFFFFF));
	}
}
