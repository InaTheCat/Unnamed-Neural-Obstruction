package states;

import flixel.FlxState;
import game.objects.UNOSprite;
import game.objects.UNOText;

class Tests extends UNOState
{
	var possibles:Array<String> = [
		'Lorem ipsum dolor sit amet consectetur\nadipiscing elit commodo penatibus class bibendum,\nnulla inceptos primis fames ante himenaeos augue tempus nascetur.',
		'long ass message for test omgomgomgomgomgomgomgomgomgomgomgomgomgomgomgomgomgomgomgomgomgomg',
		'.',
		'trying\nlong\nmessages\nin\nheight\nheh\nheh'
	];

	var times:Int = 0;
	var oTimes:Int = 0;

    override public function create() {
        super.create();

	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(() -> new MainMenuState());
	}
}