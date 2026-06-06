package game.notes;

import flixel.FlxSprite;
import utils.Paths;

class Note extends FlxSprite
{
	public var dir:Int = 0; // dir para que sea mas comodo
	public var scrollSpeed:Float = 300;

	public function new(x:Float, y:Float, dir:Int = 0)
	{
		super(x, y);

		this.dir = dir;

		frames = Paths.getSparrowAtlas('game/notes/default');

		switch (dir % 4)
		{
			case 0:
				animation.addByPrefix('scroll', 'purple0');
			case 1:
				animation.addByPrefix('scroll', 'blue0');
			case 2:
				animation.addByPrefix('scroll', 'green0');
			case 3:
				animation.addByPrefix('scroll', 'red0');
		}

		animation.play('scroll');

		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// nota sube
		y -= scrollSpeed * elapsed;
	}
}