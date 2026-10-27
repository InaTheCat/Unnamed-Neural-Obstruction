package states;

import game.notes.StrumLine;

class PlayState extends FlxState
{
	var strum:StrumLine;
	var floor:FlxSprite;
	var bg:FlxSprite;

	override public function create()
	{
		super.create();
		add(bg = new FlxSprite().loadGraphic(Paths.image('stages/stage/back')));
		add(floor = new FlxSprite().loadGraphic(Paths.image('stages/stage/floor')));
		add(strum = new StrumLine(50, 50, 6));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Q)
		{
			strum.notes[0].playAnim('press', true);
			strum.splashes[0].hit();
		}
		else if (FlxG.keys.justReleased.Q)
			strum.notes[0].playAnim('static', true);

		if (FlxG.keys.justPressed.W)
		{
			strum.notes[1].playAnim('press', true);
			strum.splashes[1].hit();
		}
		else if (FlxG.keys.justReleased.W)
			strum.notes[1].playAnim('static', true);

		if (FlxG.keys.justPressed.E)
		{
			strum.notes[2].playAnim('press', true);
			strum.splashes[2].hit();
		}
		else if (FlxG.keys.justReleased.E)
			strum.notes[2].playAnim('static', true);

		if (FlxG.keys.justPressed.I)
		{
			strum.notes[3].playAnim('press', true);
			strum.splashes[3].hit();
		}
		else if (FlxG.keys.justReleased.I)
			strum.notes[3].playAnim('static', true);

		if (FlxG.keys.justPressed.O)
		{
			strum.notes[4].playAnim('press', true);
			strum.splashes[4].hit();
		}
		else if (FlxG.keys.justReleased.O)
			strum.notes[4].playAnim('static', true);

		if (FlxG.keys.justPressed.P)
		{
			strum.notes[5].playAnim('press', true);
			strum.splashes[5].hit();
		}
		else if (FlxG.keys.justReleased.P)
			strum.notes[5].playAnim('static', true);

	}
}