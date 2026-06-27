package game;

import game.Character;
import utils.Paths;

using StringTools;

class Icon extends FlxSprite {
    public var parent:Character = null;
	public var player:Bool = false;

	/**
	 * single not like relation, like, it only has one icon heh
	**/
	public var isSingle:Bool = false;

	public var minHealth:Float = 0.2;

	public function new(parentChar:Character = null, isPlayer:Bool = false, min:Float = 0.2)
	{
        super();

        parent = parentChar;

		if (min != minHealth)
			minHealth = min;

		player = isPlayer;

		prepareIcon((parentChar != null && parentChar.icon != null && parentChar.icon.trim() != '') ? parentChar.icon : 'face');
    }

	private function prepareIcon(name:String)
	{
		var iconName:String = name != null && name.trim() != '' ? name : 'face';
		if (!Paths.exists('images/game/icons/$iconName.png'))
		{
			Logs.send('Icon "$iconName" not found, using face', 'Warning');
			iconName = 'face';
		}

		loadGraphic(Paths.image('game/icons/$iconName'));

		if (this.width <= 150)
		{
			isSingle = true;

			Logs.send('Icon got changed as ${backend.system.ANSI.coloredType('isSingle', 0xFF0055FF)}', 'Source Info');
		}

		loadGraphic(Paths.image('game/icons/$name'), true, 150, 150);

        animation.add('neutral', [0], 0, false);
		if (!isSingle)
			animation.add('loose', [1], 0, false);

        animation.play('neutral', true);

		flipX = player;
    }

    /**
    * Well, the update of the icon, exactly the animation
	 * @param ref is mostly used with `health` from `PlayState`, no?
    **/
	public function updateIcon(ref:Float)
	{
		if (isSingle)
		{
			animation.play('neutral');
			return;
		}

		animation.play(player ? (ref < minHealth ? 'neutral' : 'loose') : (ref > minHealth ? 'neutral' : 'loose'));
	}
}