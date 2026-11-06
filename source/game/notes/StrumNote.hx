package game.notes;

import flixel.math.FlxPoint;

class StrumNote extends FlxSprite
{
	var center:FlxPoint = FlxPoint.get();

	public var isDown:Bool = false;
	public var dir:Int = 0;

	public function new(x:Float = 0, y:Float = 0, dir:Int = 0)
	{
		this.dir = dir %= 4;

        super();

		frames = Paths.getSparrowAtlas('game/notes/default');
		animation.addByPrefix('static', getDir(dir), 0, false);
		animation.addByPrefix('press', '${getDir(dir, true)} press', 24, false);
		animation.addByPrefix('confirm', '${getDir(dir, true)} confirm', 24, false);
		animation.play('static');
		scale.set(0.7, 0.7);
		updateHitbox();

        setPosition(x, y);
    }

    public function playAnim(anim:String, force:Bool = false) {
		isDown = anim != 'static';

		center.set(x + width / 2, y + height / 2);

		animation.play(animation.exists(anim) ? anim : 'static', force);
		updateHitbox();

		setPosition(center.x - width / 2, center.y - height / 2);

		centerOffsets();

		center.put();
	}

	public static function getDir(dir:Int = 0, alt:Bool = false, toColor:Bool = false):String
        switch(dir){
			case 0:
				return alt ? (toColor ? 'purple' : 'left') : 'arrowLEFT';
			case 1:
				return alt ? (toColor ? 'blue' : 'down') : 'arrowDOWN';
			case 2:
				return alt ? (toColor ? 'green' : 'up') : 'arrowUP';
			case 3:
				return alt ? (toColor ? 'red' : 'right') : 'arrowRIGHT';
			default:
				return alt ? (toColor ? 'purple' : 'left') : 'arrowLEFT';
        }
}