package game;

class Combo extends FlxSpriteGroup
{
	public var ratingSprite:FlxSprite;
	public var numGroup:Array<FlxSprite>;

	private var _tCalled:Int = 0;
	private var t:Float = 0;
	private var sinceMax:Float = 2;
	private var gettingDown:Float = 0;

	var pos:FlxPoint = FlxPoint.get();

	public function new(x:Float, y:Float)
	{
		super();

		pos.set(x ?? 0, y ?? 0);

		setPosition(x ?? 0, y ?? 0);

		add(ratingSprite = new FlxSprite(x, y));
		ratingSprite.alpha = 0;
		ratingSprite.scale.set(0.75, 0.75);
		ratingSprite.updateHitbox();

		numGroup = [];
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
				sinceMax -= elapsed * 2;
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

		for (numScore in members.copy())
		{
			if (numScore == null || numScore == ratingSprite)
				continue;

			FlxTween.cancelTweensOf(numScore);
			numScore.kill();
		}

		numGroup.resize(0);

		if (ratingSprite.graphic == null || ratingSprite.graphic.key != Paths.image('game/combo/$rating'))
			ratingSprite.loadGraphic(Paths.image('game/combo/$rating'));

		ratingSprite.setPosition(x, y);
		ratingSprite.alpha = 1;

		ratingSprite.acceleration.y = 550;
		ratingSprite.velocity.set(-FlxG.random.int(-10, 10), -FlxG.random.int(140, 175));

		FlxTween.cancelTweensOf(ratingSprite);

		FlxTween.tween(ratingSprite, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {
			ease: FlxEase.smoothStepInOut,
			startDelay: 0.5,
			onComplete: (_:FlxTween) -> ratingSprite.alpha = 0
		});

		if (combo == null)
			return;

		var nums:String = Std.string(CoolUtil.zeros(Std.string(combo), 3));

		for (i in 0...nums.length)
		{
			var numScore:FlxSprite = recycle(FlxSprite);
			if (numScore.graphic == null || numScore.graphic.key != Paths.image('game/combo/${nums.charAt(i)}'))
				numScore.loadGraphic(Paths.image('game/combo/${nums.charAt(i)}'));

			numScore.setPosition(ratingSprite.x + (i * 45) + 50, ratingSprite.y + ratingSprite.height);
			numScore.revive();
			numScore.alpha = 1;
			numGroup.push(numScore);

			numScore.scale.set(0.5, 0.5);
			numScore.updateHitbox();

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
}