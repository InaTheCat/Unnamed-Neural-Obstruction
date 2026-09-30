package states;

import backend.system.ANSI;
import backend.ui.Button;
import flixel.FlxState;
import game.objects.UNOSprite;
import game.objects.UNOText;
import scripting.hscript.Script;
import states.editors.charter.sustain.High;

class Tests extends UNOState
{
	var sustain:High;
	var dissapearingSustain:High;
	var appearingSustain:High;

	var sustains:Array<High>;

    override public function create() {
        super.create();

		add(sustain = new High(50, 50, 150, 0));

		FlxTween.num(150, 400, 1, {ease: FlxEase.cubeInOut, type: PINGPONG}, (v:Float) -> sustain.setLength(v));

		add(dissapearingSustain = new High(150, 50, 150, 1));

		FlxTween.num(400, 0, 2, {ease: FlxEase.cubeInOut}, (v:Float) -> dissapearingSustain.setLength(v));

		add(appearingSustain = new High(250, 50, 0, 2));

		FlxTween.num(0, 400, 2, {startDelay: 0.5, ease: FlxEase.cubeInOut}, (v:Float) -> appearingSustain.setLength(v));

		sustains = [];

		for (i in 0...4)
		{
			var sust:High = new High(400 + (i * 25), 50, 150, i);
			add(sust);

			sustains.push(sust);
		}
	}

	var t:Float = 0;

	override public function update(elapsed:Float) {
		super.update(elapsed);

		t += elapsed;

		for (i in 0...sustains.length)
			sustains[i].setLength(100 + Math.sin((t * (i + 1) * 2)) * 50);
	}
}