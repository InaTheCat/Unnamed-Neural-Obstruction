package options;

import flixel.input.keyboard.FlxKey;

class Options {
    public static var altShooterPosition:Bool = false; // Changes the position of the TroubleShooter if you want it to be showed on the top of the screen instead of the bottom
	public static var downscroll:Bool = true; // This will change if the altShooter is true cuz... well, it wont overlap the shooter in the fucking notes

    public static var playerKeys:Array<FlxKey>=[Q, W, O, P];

	public static function init():Void
	{
		// setKeys();

		setDown();
	}

	private static function setDown()
	{
		altShooterPosition = downscroll;
    }
}