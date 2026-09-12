package states;

import backend.system.ANSI;
import flixel.FlxState;
import game.objects.UNOSprite;
import game.objects.UNOText;
import scripting.hscript.Script;

class Tests extends UNOState
{
	public var insertedScript:Script;
	public var externalScript:Script;

    override public function create() {
        super.create();

		insertedScript = new Script("
			import flixel.FlxSprite;
			import flixel.FlxG;
			import utils.Paths;

			var sprite:FlxSprite;

			function create() {
				FlxG.state.add(sprite = new FlxSprite(30, 50).loadGraphic(Paths.image('chiyo')));

				trace('inserted script');
			}
		", true);

		insertedScript.call('create');

		externalScript = new Script(Paths.script('data/scripts/uh', 'hx'));

		externalScript.call('create');
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

	}
}