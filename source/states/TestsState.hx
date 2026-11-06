package states;

import game.objects.Alphabet;

class TestsState extends FlxState {
    override public function create() {
        super.create();

        add(new Alphabet(150, 100, 'muejejjeje texto alv'));
    }
}