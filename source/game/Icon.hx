package game;

import flixel.FlxSprite;
import flixel.FlxSprite;
import game.Character;
import game.Character;
import utils.Paths;
import utils.Paths;
class Icon extends FlxSprite {
    public var parent:Character = null;
	public var player:Bool = false;

	public var minHealth:Float = 0.2;

	public function new(path:String = 'bf', isPlayer:Bool = false, min:Float = 0.2, ?parentChar:Character = null)
	{
        super();

        parent = parentChar;

		if (min != minHealth)
			minHealth = min;

		player = isPlayer;

		prepareIcon(path);
    }

	private function prepareIcon(path:String)
	{
        loadGraphic(Paths.image('game/icons/$path'), true, 150, 150);
        animation.add('neutral', [0], 0, false);
        animation.add('loose', [1], 0, false);
        animation.play('neutral', true);

		flipX = player;
    }

    /**
    * Well, the update of the icon, exactly the animation
    * @param ref is mostly used with `health` from `PlayState`
    **/
	public function updateIcon(ref:Float)
		animation.play(player ? (ref < minHealth ? 'neutral' : 'loose') : (ref > minHealth ? 'neutral' : 'loose'));
}