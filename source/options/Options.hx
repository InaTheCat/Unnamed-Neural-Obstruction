package options;

import flixel.input.keyboard.FlxKey;

class Options {
	/**
	 * Changes the position of the TroubleShooter if you want it to be showed on the top of the screen instead of the bottom
	 * (not functional rn btw)
	 */
	public static var altShooterPosition:Bool = false;

	/**
	 * This will change the `altShooterPosition` if this is true cuz... well, it wont overlap the shooter in the fucking notes
	 */
	public static var downscroll:Bool = false;

	/**
	 * lil bro doesnt do shii
	 */
    public static var playerKeys:Array<FlxKey>=[Q, W, O, P];

	/**
	 * uh?
	 */
	public static var antialiasing:Bool = true;

	/**
	 * uhm, yep, the v slice sustains, but only the anim
	 */
	public static var vSliceSustains:Bool = false;

	public static function init():Void
	{
		// setKeys();

		setDown();
	}

	private static function setDown():Void
		altShooterPosition = downscroll;
}