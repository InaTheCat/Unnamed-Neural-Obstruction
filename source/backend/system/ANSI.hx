package backend.system;

import flixel.util.typeLimit.OneOfTwo;

using StringTools;

class ANSI
{
    public static inline var RESET = "\x1b[0m";

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
	 * @param type normally for getting access to predefined colors in the `colors` of
	 *             `Logs`, this will only work if `customColor` isnt `null`,
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

		var col:Int = Logs.colors.exists(type) ? Logs.colors.get(type) : 0xFFFFFFFF;

		return '${fromHex(col)}[$type]$RESET';
	}

	/**
	 * Well, generates a colored text with a Logs type or a color... its the same
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
		if (color is String)
		{
			var col:Int = Logs.colors.exists(color) ? Logs.colors.get(color) : 0xFFFFFFFF;
			return '${fromHex(col)}$input$RESET';
		}
		else if (color is Int)
			return '${fromHex(color)}$input$RESET';

		return '';
    }
	/**
	 * it generates... uhm, a type of "Class", literally, a type-like String
	 *
	 *	`Green`, `Blue`, `Gray`
	 *   Class.variable.function();
	 *
	 * Literally js like that
	**/
	public static function coloredClass(input:Dynamic):String
	{
		var givenClass:Array<String> = Std.string(input).split('.');

		if (givenClass.length <= 1)
			return coloredText(givenClass[0], 0xFF4EC9B0);
		else
		{
			var output:String = '';

			output += '${coloredText(givenClass[0], 0xFF4EC9B0)}.';

			for (i in 1...givenClass.length - 1)
				output += '${coloredText(givenClass[i], 0xFF9CDCFE)}.';

			var lastPart:String = givenClass[givenClass.length - 1];
			output += '${coloredText(lastPart, lastPart.endsWith('()') ? 0xFFDCDCAA : 0xFF9CDCFE)}';

			return output;
		}
	}
}