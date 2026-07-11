package game;

import flixel.group.FlxSpriteGroup;

class Combo extends FlxSpriteGroup
{
	var rateGroup = new FlxSpriteGroup();
	var numGroup = new FlxSpriteGroup();

	public function new(x:Float, y:Float)
	{
		super();

		setPosition(x ?? 0, y ?? 0);

		add(rateGroup);
		add(numGroup);
	}

	public function showCombo(rating:String, combo:Int)
	{
		maxRateShowable(15);
		maxNumShowable(50);

		var rateSprite:String = Paths.exists('images/game/combo/$rating') ? Paths.image('game/combo/$rating') : Paths.image('game/combo/sick');

		var rate:FlxSprite = rateGroup.recycle(FlxSprite);

		if (rate.graphic == null || rate.graphic.key != rateSprite)
			rate.loadGraphic(rateSprite);

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

	public function maxRateShowable(max:Int)
	{
		var alive = 0;

		for (sprite in rateGroup.members)
			if (sprite != null && sprite.alive)
				alive++;

		if (alive >= max)
			for (sprite in rateGroup.members)
				if (sprite != null && sprite.alive)
				{
					FlxTween.cancelTweensOf(sprite);
					sprite.kill();
				}
	}

	public function maxNumShowable(max:Int)
	{
		var alive = 0;

		for (sprite in numGroup.members)
			if (sprite != null && sprite.alive)
				alive++;

		if (alive >= max)
			for (sprite in numGroup.members)
				if (sprite != null && sprite.alive)
				{
					FlxTween.cancelTweensOf(sprite);
					sprite.kill();
				}
	}
}