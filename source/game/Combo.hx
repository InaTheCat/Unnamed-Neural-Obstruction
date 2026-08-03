package game;

import backend.system.ANSI;

class Combo extends FlxSpriteGroup
{
	public var rateGroup = new FlxSpriteGroup();
	public var numGroup = new FlxSpriteGroup();

	public var comboLimit:Int = 5;
	public var numLimit:Int = 15;

	public function new(x:Float, y:Float)
	{
		super();

		setPosition(x ?? 0, y ?? 0);

		add(rateGroup);
		add(numGroup);
	}

	public function showCombo(rating:String, combo:Int)
	{
		limitShowable(rateGroup, comboLimit);
		limitShowable(numGroup, numLimit);

		var rate:FlxSprite = rateGroup.recycle(FlxSprite);

		if (rate.graphic == null || rate.graphic.key != Paths.image('game/combo/$rating'))
			rate.loadGraphic(Paths.image('game/combo/$rating'));

		rate.revive();

		rate.alpha = 1;
		rate.scale.set(0.75, 0.75);
		rate.updateHitbox();
		rate.setPosition(this.x, this.y);

		rate.acceleration.y = 550;
		rate.velocity.set(-FlxG.random.int(-10, 10), -FlxG.random.int(140, 175));

		FlxTween.cancelTweensOf(rate);

		FlxTween.tween(rate, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {
			ease: FlxEase.smoothStepInOut,
			startDelay: 0.5,
			onComplete: (_:FlxTween) -> rate.kill()
		});

		var nums:String = Std.string(CoolUtil.zeros(Std.string(combo), 3));

		for (i in 0...nums.length)
		{
			var numScore:FlxSprite = numGroup.recycle(FlxSprite);

			var rateSprite = Paths.image('game/combo/${nums.charAt(i)}');

			if (numScore.graphic == null || numScore.graphic.key != rateSprite)
				numScore.loadGraphic(rateSprite);

			numScore.revive();

			numScore.alpha = 1;
			numScore.scale.set(0.5, 0.5);
			numScore.updateHitbox();

			numScore.setPosition(this.x + (i * 45) + 60, rate.height + 180);

			numScore.acceleration.y = 550;
			numScore.velocity.set(-FlxG.random.int(-10, 10), -FlxG.random.int(140, 175));

			FlxTween.cancelTweensOf(numScore);

			FlxTween.tween(numScore, {alpha: 0}, (Conductor.stepCrochet / 1000) * 7, {
				ease: FlxEase.smootherStepInOut,
				startDelay: 0.5,
				onComplete: (_:FlxTween) -> numScore.kill()
			});
		}
	}

	function limitShowable(group:FlxSpriteGroup, max:Int):Void
	{
		if (group == rateGroup && max <= 1)
		{
			Logs.send('rateGroup limit is too low, replaced with ${ANSI.coloredType('2', 0xFFAAAAFF)}',
				{type: 'Warning', overrideShooterText: 'rateGroup limit is too long, replaced with 2'});
			comboLimit = 2;
		}

		if (group == numGroup && max <= 2)
		{
			Logs.send('numGroup limit is too low, replaced with ${ANSI.coloredType('3', 0xFFAAAAFF)}',
				{type: 'Warning', overrideShooterText: 'numGroup limit is too long, replaced with 3'});
			numLimit = 3;
		}

		var alive = 0;

		for (sprite in group.members)
			if (sprite != null && sprite.alive)
				alive++;

		if (alive > max)
			for (sprite in group.members)
				if (sprite != null && sprite.alive)
				{
					FlxTween.cancelTweensOf(sprite);
					sprite.kill();
				}
	}
}