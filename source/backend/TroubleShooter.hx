package backend;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class TroubleShooter extends FlxBasic {
    public static var instance:TroubleShooter;

    public var troubleShooter:FlxTypedSpriteGroup<Dynamic>;
    public var troubleText:FlxText;
    public var troubleBg:FlxSprite;
    private var hideTimer:FlxTimer = null;

    public var typeColors:Map<String, Int> = [
        'Info' => 0x0000FF,
        'Warning' => 0xFFFF00,
        'Error' => 0xFF0000,
		'None' => 0xFFFFFFFF,
		'PSeScript' => 0xFFAAAAAA,
		'PSeWarning' => 0xFFFFFFAA,
		'PSeError' => 0xFFFF5555
    ];

    public function new() {
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

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        troubleShooter.update(elapsed);
    }

	override public function draw():Void
	{
        troubleShooter.draw();
    }

    public function send(message:String, ?shootType:String = 'Info', ?displayTime:Float = 2):Void {
        FlxTween.cancelTweensOf(troubleShooter);
        if (hideTimer != null) hideTimer.cancel();

        displayTime ?? 2;
        shootType ?? 'Info';

        troubleShooter.alpha = 0;
        troubleShooter.setPosition(-troubleShooter.width, FlxG.height - troubleBg.height);

        troubleText.text = message + (shootType != 'None' ? '\n\n[$shootType]' : '');

        troubleText.color = typeColors.exists(shootType) ? typeColors[shootType] : 0xFFFFFFFF;

        // Update shoot troubleBg
        troubleBg.makeGraphic(Std.int(troubleText.textField.textWidth + 40), Std.int(troubleText.textField.textHeight + 40), 0xFFFFFFFF);

        troubleText.y = FlxG.height - troubleBg.height;

        troubleBg.setPosition(troubleText.x - 20, troubleText.y - 20);
        troubleBg.updateHitbox();

        // Notification appears
        FlxTween.tween(troubleShooter, {x: -10, alpha: 0.6}, 0.5, {ease: FlxEase.quadOut, onComplete: function(_) {
            hideTimer = new FlxTimer().start(displayTime, function(_) {
                hide();
            });
        }});
    }

    private function hide():Void {
        FlxTween.cancelTweensOf(troubleShooter);
        FlxTween.tween(troubleShooter, {x: -troubleBg.width, alpha: 0}, 0.7, {
            ease: FlxEase.quadIn,
            onComplete: (_) -> {
                troubleShooter.alpha = 0;
            }
        });
    }
}