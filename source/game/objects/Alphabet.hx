package game.objects;

import flixel.group.FlxSpriteContainer;
import flixel.math.FlxPoint;

using StringTools;

class Alphabet extends FlxSpriteContainer
{
	public var text(get, set):String;
	
	function get_text():String
		return _text;

	private var _text:String = '';
	private var _gotReloaded:Bool = false;

	public function new(x:Float = 0, y:Float = 0, text:Dynamic = ''):Void
	{
		super(x, y);

		this.text = text;
	}

	function prepareAlphabet(text:String):Void
	{
		var daText:Array<String> = text.split('');

		var totalWidth:Float = daText.length * 50;
		var startX:Float = -totalWidth * 0.5;

		for (i => e in daText)
		{
			var letter:FlxSprite = new FlxSprite(startX + i * 50);
			letter.frames = Paths.getSparrowAtlas('menus/alphabet');

			if (e == '.' || e == ',')
				letter.y += 50;

			e = AlphabetUtil.check(e, {full: text, textNum: i});

			letter.animation.addByPrefix(e.toLowerCase(), (e.toLowerCase() == ' ' ? 'a' : e.toLowerCase()) + '0');
			letter.animation.play(e.toLowerCase());

			add(letter);

			letter.antialiasing = Options.antialiasing;

			if (e.trim() == '' || (e == '\\' || e == '\n'))
				letter.visible = false;
		}

		updateHitbox();
	}

	function set_text(value:String):String
	{
		if (_text == value)
			return value;

		var center:FlxPoint = FlxPoint.get(x + width * 0.5, y + height * 0.5);

		_text = value;

		for (e in members)
		{
			if (e != null)
			{
				remove(e);
				e.destroy();
			}
		}

		prepareAlphabet(value);

		setPosition(center.x - width * 0.5, center.y - height * 0.5);

		center.put();

		return value;
	}

	public function destroyAlphabet()
	{
		if (members == null || members.length == 0)
		{
			Logs.send('Alphabet aint even real gng wtf', Error);

			return;
		}

		for (e in members)
		{
			if (e != null)
				e.destroy();
		}

		clear();
		destroy();
	}
}

class AlphabetUtil {
	private static final replacement:Map<String, String> = [
		// Numbers
		'0' => 'zero',
		'1' => 'one',
		'2' => 'two',
		'3' => 'three',
		'4' => 'four',
		'5' => 'five',
		'6' => 'six',
		'7' => 'seven',
		'8' => 'eight',
		'9' => 'nine',
		// Brackets
		'{' => 'curlybracket-left',
		'}' => 'curlybracket-right',
		'(' => 'roundbracket-left',
		')' => 'roundbracket-right',
		'[' => 'squarebracket-left',
		']' => 'squarebracket-right',
		'<' => 'anglebracket-left',
		'>' => 'anglebracket-right',
		// random bs???
		"'" => 'singlequote',
		'"' => 'doulequote',
		"$" => 'dollar',
		"%" => 'percent',
		"!" => 'exclamationmark',
		"#" => 'pound',
		'&' => 'ampersand',
		'/' => 'slash',
		'=' => 'equal',
		'?' => 'questionmark',
		'.' => 'period',
		'-' => 'hypen',
		'~' => 'tilde',
		'|' => 'verticalbar',
		'←' => 'arrow-left',
		'↑' => 'arrow-down',
		'↓' => 'arrow-up',
		'→' => 'arrow-right',
		'^' => 'caret',
		'\\' => 'backslash',
		'×' => 'multiply',
		'@' => 'at',
		'æ' => 'ash',
		'œ' => 'ethel'
	];

	public static function check(input:String, extra:{full:String, textNum:Int}):String
	{
        var found:Bool = replacement.exists(input);

		if (found)
			Logs.internal('[${extra.full} | Index: ${extra.textNum}] Letter given has replacement [$input -> ${replacement.get(input)}]');

        return found ? replacement.get(input) : input;
    }
}