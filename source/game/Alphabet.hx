package game;

import flixel.group.FlxSpriteContainer;
import flixel.math.FlxPoint;
import utils.AlphabetUtil;

using StringTools;

class Alphabet extends FlxSpriteContainer
{
	public var pos:FlxPoint = FlxPoint.get();
    public var text:String = '';

	private var _iText:String = '';
	private var _gotReloaded:Bool = false;

	public function new(x:Float = 0, y:Float = 0, text:Dynamic = ''):Void
	{
		super();

		this.text = text;

		pos.set(x ?? 0, y ?? 0);

		prepareAlphabet(Std.string(text));
	}

	function prepareAlphabet(text:String):Void
	{
		var daText:Array<String> = text.split('');

		for (i => e in daText)
		{
			var letter:FlxSprite = new FlxSprite(i * 50);
			letter.frames = Paths.getSparrowAtlas('menus/alphabet');

			e = AlphabetUtil.check(e);

			letter.animation.addByPrefix(e, e + '0');
			letter.animation.play(e);

			add(letter);

			if (e == ' ')
				letter.visible = false;
		}

		_iText = text;

		if (_gotReloaded)
		{
			Logs.send('Alphabet got reloaded', {type: 'Source Info'});
			_gotReloaded = false;
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_iText != text)
		{
			Logs.send('Reloading da Alphabet from $_iText to $text', {type: 'Source Info'});
			_gotReloaded = true;

			for (e in members)
			{
				remove(e);
				e.destroy();
			}

			prepareAlphabet(text);
		}
	}
}