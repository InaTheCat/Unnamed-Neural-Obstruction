package states;

import backend.system.ANSI;
import backend.ui.Button;
import flixel.FlxState;
import game.objects.UNOSprite;
import game.objects.UNOText;
import scripting.hscript.Script;

class Tests extends UNOState
{
	var button:Button;

    override public function create() {
        super.create();

		button = new Button(100, 30, 'but when', 250, 100);
		button.onClick = () -> trace('hell nah');
		add(button);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

	}
}