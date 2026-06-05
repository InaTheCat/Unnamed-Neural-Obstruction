package game;

import flixel.FlxSprite;
import flixel.FlxSprite;
import game.Character;
import game.Character;
import utils.Paths;
import utils.Paths;
class Icon extends FlxSprite {
    public var parent:Character = null;
    public var opp:Bool = false;

    public var minHealth:Float = 1.8;
    public var maxHealth:Float = 0.5;

    public function new(path:String = 'bf', isOpp:Bool = false, min:Float = 2.8, max:Float = 0.2, ?parentChar:Character = null) {
        super();

        parent = parentChar;

        if (min != minHealth) minHealth = min;
        if (max != maxHealth) maxHealth = max;

        opp = isOpp;

        startIcon(path);
    }

    private function startIcon(path:String) {
        loadGraphic(Paths.image('game/icons/$path'), true, 150, 150);
        animation.add('neutral', [0], 0, false);
        animation.add('loose', [1], 0, false);
        animation.play('neutral', true);

        flipX = !opp;
    }

    /**
    * Well, the update of the icon, exactly the animation
    * @param ref is mostly used with `health` from `PlayState`
    **/
    public function updateIcon(ref:Float) {
        var isDying:Bool = opp ? (ref <= minHealth) : (ref >= maxHealth);
        var mode:String = isDying ? 'loose' : 'neutral';

        if (animation.curAnim?.name != mode)
            animation.play(mode);
    }
}