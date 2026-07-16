package states;

import game.Alphabet;

class Tests extends UNOState {
	var alphabet:Alphabet;

    override public function create() {
        super.create();

		add(alphabet = new Alphabet(50, 50, 'yo ese'));
    }

	override public function update(elapsed:Float) {
		super.update(elapsed);

	}
}