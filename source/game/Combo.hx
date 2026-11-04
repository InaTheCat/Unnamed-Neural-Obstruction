package game;

import backend.system.ANSI;

class Combo extends FlxSpriteGroup
{
	public var rateGroup = new FlxSpriteGroup();
	public var numGroup = new FlxSpriteGroup();

	public var comboLimit(default, set):Int = 5;
	public var numLimit(default, set):Int = 15;

	private var _tCalled:Int = 0;
	private var t:Float = 0;
	private var sinceMax:Float = 2;
	private var gettingDown:Float = 0;

	var pos:FlxPoint = FlxPoint.get();

	function set_comboLimit(v:Int){
		if (v <= 2)
			Logs.send('comboLimit replaced with 2 cuz, well, itll look bad if its less than 2... mh', Warning);

		return v <= 2 ? 2 : v;
	}

	function set_numLimit(v:Int){
		if (v <= 3)
			Logs.send('numLimit replaced with 3 cuz, well, itll look bad if its less than 3... mh', Warning);

		return v <= 3 ? 3 : v;
	}

	public function new(x:Float, y:Float)
	{
		super();

		pos.set(x ?? 0, y ?? 0);

		setPosition(x ?? 0, y ?? 0);

		add(rateGroup);
		add(numGroup);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (_tCalled != 0){
			t += elapsed * 50;

			if (t >= 1){
				t = 0;
				_tCalled--;
			}

			if (sinceMax != 0 && _tCalled >= 750){
				sinceMax -= elapsed * 5;
				if (sinceMax <= 0){
					sinceMax = 2;
					_tCalled = Std.int(_tCalled / 2);
				}
			}
		}
	}

	public function showCombo(rating:String, ?combo:Int)
	{
		_tCalled++;

		if (_tCalled >= 750)
			return;

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

		if (combo == null)
			return;

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

		setPosition(pos.x, pos.y);
	}

	function limitShowable(group:FlxSpriteGroup, max:Int):Void
	{
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