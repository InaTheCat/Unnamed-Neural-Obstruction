package states;

import game.notes.StrumLine;

class PlayState extends FlxState
{
	var strum:StrumLine;

	override public function create()
	{
		super.create();
		add(strum = new StrumLine(50, 50));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Q)
			strum.playAnim(0, 'press', true);
		else if (FlxG.keys.justReleased.Q)
			strum.playAnim(0, 'static', true);

		if (FlxG.keys.justPressed.W)
			strum.playAnim(1, 'press', true);
		else if (FlxG.keys.justReleased.W)
			strum.playAnim(1, 'static', true);

		if (FlxG.keys.justPressed.O)
			strum.playAnim(2, 'press', true);
		else if (FlxG.keys.justReleased.O)
			strum.playAnim(2, 'static', true);

		if (FlxG.keys.justPressed.P)
			strum.playAnim(3, 'press', true);
		else if (FlxG.keys.justReleased.P)
			strum.playAnim(3, 'static', true);
	}
}