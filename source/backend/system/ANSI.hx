package backend.system;

class ANSI {
    public static inline var RESET = "\x1b[0m";

    public static inline function fromRGB(r:Int, g:Int, b:Int):String {
        return '\x1b[38;2;$r;$g;$b';
    }

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

		if (customColor != null)
			return '${fromHex(customColor)}$type$RESET';

        var shooterColor:Int = TroubleShooter.instance.typeColors.get(type) ?? 0xFFFFFFFF;

        return '${fromHex(shooterColor)}[$type]$RESET';
    }
}