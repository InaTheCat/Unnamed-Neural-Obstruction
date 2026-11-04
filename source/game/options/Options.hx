package game.options;

import flixel.input.keyboard.FlxKey;

class Options {
	public static var antialiasing:Bool = true;

    public static var keybinds:Map<Int, Array<FlxKey>> = [
        1 => [SPACE],
        2 => [Q, P],
        3 => [Q, SPACE, P],
        4 => [Q, W, O, P],
        5 => [Q, W, SPACE, O, P],
        6 => [Q, W, E, I, O, P],
        7 => [Q, W, E, SPACE, I, O, P],
        8 => [Q, W, E, R, U, I, O, P],
        9 => [Q, W, E, R, SPACE, U, I, O, P]
    ];
}