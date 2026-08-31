package backend;

import backend.system.Logs;
import game.objects.UNOText;

class TroubleShooter extends FlxCamera
{
	public static var typeColors:Map<String, Int> = [
		'Debug' => 0x00FF00,
		'Info' => 0x0000FF,
		'Warning' => 0xFFFF00,
		'Error' => 0xFF0000,
		'None' => 0xFFFFFFFF,
		'Trace' => 0xFF000055,
		'Source Info' => 0xAA00FF,
		'PSeScript' => 0xFFAAAAAA,
		'PSeWarning' => 0xFFFFFFAA,
		'PSeError' => 0xFFFF5555
    ];

	public static var troubleShooters:FlxSpriteGroup = new FlxSpriteGroup();
	public static var actualShooters:Int = 0;

	public static var instance:TroubleShooter;

	public function new()
	{
		instance = this;

		super();

		bgColor = 0x00000000;

		FlxG.state.add(troubleShooters).camera = this;
		troubleShooters.scrollFactor.set();
	}

	public static function shoot(message:Dynamic, shootType:LogType = Info, shooterTime:Float = 4):Void
	{
		var shooter:FlxSpriteGroup = new FlxSpriteGroup();

		var text:UNOText = new UNOText(0, 0, '$message\n\n[$shootType]', {
			size: 16,
			color: typeColors.exists(shootType) ? typeColors.get(shootType) : 0xFFFFFFFF,
			alignment: LEFT,
			borderStyle: OUTLINE,
			borderColor: 0xFF000000
		});

		var bg:FlxSprite = new FlxSprite().makeGraphic(Std.int(text.textField.textWidth + 20), Std.int(text.textField.textHeight + 20), 0xFFFFFFFF);
		bg.color = typeColors.exists(shootType) ? typeColors.get(shootType) : 0xFFFFFFFF;

		shooter.add(bg);
		shooter.add(text);

		text.attachTo(bg, {x: 5, y: 7});

		shooter.setPosition(-bg.width, FlxG.height - 50);

		troubleShooters.add(shooter).alpha = 0;

		repositionShooters();

		actualShooters++;

		if (actualShooters > 7)
		{
			var oldest:FlxSpriteGroup = cast troubleShooters.members[0];

			if (oldest != null && oldest != shooter)
			{
				FlxTween.cancelTweensOf(oldest);

				var oldestText:UNOText = null;

				for (member in oldest.members)
				{
					if (Std.isOfType(member, UNOText))
					{
						oldestText = cast member;
						break;
					}
				}

				FlxTween.tween(oldest, {x: -oldest.width, alpha: 0}, 0.5,
					{ease: FlxEase.sineInOut, onComplete: (_:FlxTween) -> removeShooter(oldest, oldestText)});
			}
		}


		if (shooterTime == 0)
		{
			shooter.alpha = 0.5;
			new FlxTimer().start(2, (_:FlxTimer) -> removeShooter(shooter, text));
		}
		else
		{
			FlxTween.tween(shooter, {x: 0, alpha: shooterTime / 4}, 0.5, {ease: FlxEase.sineInOut});
			FlxTween.tween(shooter, {x: -shooter.width, alpha: 0}, shooterTime / 4,
				{startDelay: shooterTime, ease: FlxEase.sineInOut, onComplete: (_:FlxTween) -> removeShooter(shooter, text)});
		}
	}

	private static function repositionShooters():Void
	{
		var y:Float = FlxG.height - 15;

		for (i in 0...troubleShooters.members.length)
		{
			var index:Int = troubleShooters.members.length - 1 - i;
			var shooter:FlxSpriteGroup = cast troubleShooters.members[index];

			if (shooter == null)
				continue;

			y -= shooter.height;

			FlxTween.tween(shooter, {y: y}, 0.5, {ease: FlxEase.sineInOut});

			y -= 10;
		}
	}

	private static function removeShooter(shooter:FlxSpriteGroup, text:UNOText):Void
	{
		text.deAttachAll();

		troubleShooters.remove(shooter, true);

		actualShooters--;

		repositionShooters();
	}
}