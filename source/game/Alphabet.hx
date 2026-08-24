package game;

import flixel.group.FlxSpriteContainer;
import flixel.math.FlxPoint;
import utils.AlphabetUtil;

using StringTools;

class Alphabet extends FlxSpriteContainer
{
	public var pos:FlxPoint = FlxPoint.get();
	public var text(get, set):String;
	
	function get_text():String
		return _text;

	private var _text:String = '';
	private var _gotReloaded:Bool = false;

	public function new(x:Float = 0, y:Float = 0, text:Dynamic = ''):Void
	{
		super(x, y);

		this.text = text;

		pos.set(x ?? 0, y ?? 0);

		prepareAlphabet(Std.string(text));
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

			e = AlphabetUtil.check(e);

			letter.animation.addByPrefix(e.toLowerCase(), (e.toLowerCase() == ' ' ? 'a' : e.toLowerCase()) + '0');
			letter.animation.play(e.toLowerCase());

			add(letter);

			letter.antialiasing = Options.antialiasing;

			if (e == ' ')
				letter.visible = false;
		}

		updateHitbox();
	}

	function set_text(value:String):String
	{
		if (_text == value)
			return value;

		var centerX:Float = x + width * 0.5;
		var centerY:Float = y + height * 0.5;

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

		x = centerX - width * 0.5;
		y = centerY - height * 0.5;

		return value;
	}

	public function destroyAlphabet()
	{
		if (members == null || members.length == 0)
		{
			Logs.send('Alphabet aint even real gng wtf', {type: Error});

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