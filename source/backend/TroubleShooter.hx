package backend;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText.FlxTextBorderStyle;

class TroubleShooter extends FlxBasic
{
	public static var instance:TroubleShooter;

	public static var troubleShooter:FlxTypedSpriteGroup<Dynamic>;
	public static var troubleText:FlxText;
	public static var troubleBg:FlxSprite;

	private static var hideTimer:FlxTimer = null;

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

	public function new()
	{
		super();
		instance = this;

		troubleShooter = new FlxTypedSpriteGroup<Dynamic>();
		troubleShooter.scrollFactor.set();
		troubleShooter.alpha = 0;

		troubleBg = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
		troubleBg.alpha = 0.75;

		troubleText = new FlxText(20, 10, 0, 'Initial Message', 16);
		troubleText.setFormat(null, 16, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);

		troubleShooter.add(troubleBg);
		troubleShooter.add(troubleText);
	}

	public static function setCam(cam:FlxCamera):Void
	{
		if (cam == troubleShooter.camera)
		{
			Logs.send('The TroubleShooter is in that camera at this moment', {type: SourceInfo});
			return;
		}

		troubleShooter.cameras = [cam];
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		troubleShooter.update(elapsed);
	}

	override public function draw():Void
		troubleShooter.draw();

	public static function shoot(message:String, ?shootType:String = 'Info', ?displayTime:Float = 2):Void
	{
		FlxTween.cancelTweensOf(troubleShooter);
		if (hideTimer != null)
			hideTimer.cancel();
		displayTime ?? 2;
		shootType ?? 'Info';

		troubleShooter.alpha = 0;
		troubleShooter.setPosition(-troubleShooter.width, FlxG.height - troubleBg.height);

		troubleText.text = message + (shootType != 'None' ? '\n\n[$shootType]' : '');

		troubleText.setFormat(null, 16, typeColors.exists(shootType) ? typeColors[shootType] : 0xFFFFFFFF, 'left', FlxTextBorderStyle.OUTLINE, 0xFF000000);

		troubleBg.makeGraphic(Std.int(troubleText.textField.textWidth + 40), Std.int(troubleText.textField.textHeight + 40), 0xFFFFFFFF);

		troubleText.y = FlxG.height - troubleBg.height;

		troubleBg.setPosition(troubleText.x - 20, troubleText.y - 20);
		troubleBg.updateHitbox();

		FlxTween.tween(troubleShooter, {x: -10, alpha: 0.6}, 0.5, {
			ease: FlxEase.quadOut,
			onComplete: function(_)
			{
				hideTimer = new FlxTimer().start(displayTime, function(_)
				{
					hide();
				});
			}
		});
	}

	private static function hide():Void
	{

		FlxTween.cancelTweensOf(troubleShooter);
		FlxTween.tween(troubleShooter, {x: -troubleBg.width, alpha: 0}, 0.7, {
			ease: FlxEase.quadIn,
			onComplete: (_) -> troubleShooter.alpha = 0
		});
	}
}