package backend.system;

import flixel.util.typeLimit.OneOfTwo;

class ANSI {
	public static var shooter:Map<String, Int> = new Map();

    public static inline var RESET = "\x1b[0m";

	public static inline function refreshShooter():Void
	{
		if (TroubleShooter.instance != null)
			shooter = TroubleShooter.instance.typeColors.copy();
		else if (shooter == null)
			shooter = new Map();
	}

	public static inline function fromRGB(r:Int, g:Int, b:Int):String
		return '\x1b[38;2;$r;$g;$b';

    public static function fromHex(color:Int):String {
        var r = (color >> 16) & 0xFF;
        var g = (color >> 8) & 0xFF;
        var b = color & 0xFF;

        return '\x1b[38;2;${r};${g};${b}m';
    }

	/**
	 * u can generate ANSI text easily with ts
	 * @param type normally for getting access to predefined colors in the `typeColors` of
	 *             the `TroubleShooter`, this will only work if `customColor` isnt `null`,
	 *             if `customColor` isnt null, `type` will convert into the message that
	 *             will be colored (what a long doc)
	 * 
	 * @param customColor the value is commonly `null`. This var contains an FlxColor that
	 *                    will color the `type` text in the console
	**/
	public static function coloredType(type:String, ?customColor:FlxColor = null):String
	{
        if (type == 'None') return '';

		refreshShooter();

		if (customColor != null)
			return '${fromHex(customColor)}$type$RESET';

		var col:Int = shooter.exists(type) ? shooter.get(type) : 0xFFFFFFFF;

		return '${fromHex(col)}[$type]$RESET';
	}

	/**
	 * Well, generates a colored text with a TroubleShooter type or a color... its the same
	 * thing that `coloredType` does, but without some rules and without `[]` for encapsuling
	 * the type inside it. This tho, returns a clean text
	 *
	 * @param input
	 *      well uhm, the text
	 *
	 * @param color
	 *      This can be a `String` or an `Int` (Color),
	 *      if its a String, then itll find for a Shooter type.
	 *      if its a Int, well, u can guess what it does
	**/
	public static function coloredText(input:Dynamic, color:OneOfTwo<String, Int>):String
	{
		refreshShooter();

		if (color is String)
		{
			var col:Int = shooter.exists(color) ? shooter.get(color) : 0xFFFFFFFF;
			return '${fromHex(col)}$input$RESET';
		}
		else if (color is Int)
			return '${fromHex(color)}$input$RESET';

		return '';
    }
}