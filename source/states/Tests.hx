package states;

import game.Alphabet;

class Tests extends UNOState {
	var alphabet:Alphabet;

	var time:FlxText;

    override public function create() {
        super.create();

		CoolUtil.playMusic('freakyMenu', 1, false, {fadeOut: true});

		Conductor.time(105000);

		add(time = new FlxText(0, 0, 0, '0/0', 64).setFormat(null, 64, 0xFFFFFFFF, 'center'));
		time.screenCenter();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		time.text = FlxG.sound?.music?.time + ' / ' + FlxG.sound?.music?.length;
	}
}