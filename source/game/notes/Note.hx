package game.notes;

import flixel.FlxSprite;
import utils.Paths;

class Note extends FlxSprite
{
	public var dir:Int = 0; // dir para que sea mas comodo
	public var scrollSpeed:Float = 300;

	public var strumTime:Float = 0;
	public var sustain:Float = 0;
	public var isHold:Bool = false;

	public var whenhit:Bool = false;
	public var holding:Bool = false;
	public var rewardsustainnote:Float = 0;
	public var holdScoreGiven:Int = 0; // who is this

	public function new(x:Float, y:Float, dir:Int = 0, strumTime:Float = 0, sustain:Float = 0)
	{
		super(x, y);

		this.dir = dir;
		this.strumTime = strumTime;
		this.sustain = sustain;
		this.isHold = sustain > 0;

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

	}
}