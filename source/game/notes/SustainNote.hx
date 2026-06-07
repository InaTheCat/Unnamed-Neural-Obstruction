package game.notes;

import flixel.FlxSprite;
import utils.Paths;

class SustainNote extends FlxSprite
{
	public var dir:Int = 0;
	public var cola:Bool = false;

	public var origenNote:Note;
	public var lengthPixels:Float = 0;

	public var strumTime:Float = 0;
	public var sustainLength:Float = 0;

	public var normalScaleY:Float = 0.7;
	public var baseHeight:Float = 0;
	public var fullHeight:Float = 0;

	public var pair:SustainNote;

	public function new(x:Float, y:Float, dir:Int = 0, cola:Bool = false, lengthPixels:Float = 0, alphaValue:Float = 0.5)
	{
		super(x, y);

		this.dir = dir;
		this.cola = cola;
		this.lengthPixels = lengthPixels;

		frames = Paths.getSparrowAtlas('game/notes/default');

		if (cola)
		{
			switch (dir % 4)
			{
				case 0: animation.addByPrefix('hold', 'pruple end hold');
				case 1: animation.addByPrefix('hold', 'blue hold end');
				case 2: animation.addByPrefix('hold', 'green hold end');
				case 3: animation.addByPrefix('hold', 'red hold end');
			}
		}
		else
		{
			switch (dir % 4)
			{
				case 0: animation.addByPrefix('hold', 'purple hold piece');
				case 1: animation.addByPrefix('hold', 'blue hold piece');
				case 2: animation.addByPrefix('hold', 'green hold piece');
				case 3: animation.addByPrefix('hold', 'red hold piece');
			}
		}

		animation.play('hold');

		

		scale.set(0.7, 0.7);
		updateHitbox();

		alpha = alphaValue;

		baseHeight = height;
		fullHeight = lengthPixels;

		if (!cola && lengthPixels > 0)
		{
			scale.y = normalScaleY * (lengthPixels / baseHeight);
			updateHitbox();
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}