package backend;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class TroubleShooter extends FlxBasic {
    public static var instance:TroubleShooter;

    private static var iNum:Int = 0;

    public var troubleShooter:FlxTypedSpriteGroup<Dynamic>;
    public var troubleText:FlxText;
    public var troubleBg:FlxSprite;
    private var hideTimer:FlxTimer = null;

    public var typeColors:Map<String, Int> = [
        'Info'       => 0xFF4444FF,
        'Warning'    => 0xFFFFDD00,
        'Error'      => 0xFFFF4444,
        'None'       => 0xFFFFFFFF,
        'PSeScript'  => 0xFFAAAAAA,
        'PSeWarning' => 0xFFFFFFAA,
        'PSeError'   => 0xFFFF5555
    ];

    public function new() {
        super();
        instance = this;

        troubleShooter = new FlxTypedSpriteGroup<Dynamic>();
        troubleShooter.scrollFactor.set(0, 0);
        troubleShooter.alpha = 0;

        troubleBg = new FlxSprite(0, 0).makeGraphic(1, 1, 0xFF222222);
        troubleBg.alpha = 0.82;

        troubleText = new FlxText(10, 10, 0, '', 16);
        troubleText.setFormat(null, 16, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);

        troubleShooter.add(troubleBg);
        troubleShooter.add(troubleText);
    }

    public inline function setCam(cam:FlxCamera):Void
        troubleShooter.cameras = [cam];

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        troubleShooter.update(elapsed);
    }

    override public function draw():Void {
        troubleShooter.draw();
    }

    public function send(message:String, ?shootType:String = 'Info', ?displayTime:Float = 2):Void {
        iNum++;
        trace('preShoot | P:[$message, $shootType, $displayTime] | $iNum');

        FlxTween.cancelTweensOf(troubleShooter);
        if (hideTimer != null) {
            hideTimer.cancel();
            hideTimer = null;
        }

        if (displayTime == null) displayTime = 2;
        if (shootType == null) shootType = 'Info';

        troubleText.text = message + (shootType != 'None' ? '\n[$shootType]' : '');
        troubleText.color = typeColors.exists(shootType) ? typeColors[shootType] : 0xFFFFFFFF;

        var textW:Int = Std.int(troubleText.textField.textWidth + 20);
        var textH:Int = Std.int(troubleText.textField.textHeight + 20);
        troubleBg.makeGraphic(textW + 20, textH + 20, 0xFF222222);
        troubleBg.updateHitbox();

        troubleBg.x = 0;
        troubleBg.y = 0;
        troubleText.x = 10;
        troubleText.y = 10;

        troubleShooter.setPosition(-troubleBg.width - 20 , FlxG.height - troubleBg.height - 10);
        troubleShooter.alpha = 1;

        FlxTween.tween(troubleShooter, {x: 10}, 0.45, {
            ease: FlxEase.quadOut,
            onComplete: function(_) {
                hideTimer = new FlxTimer().start(displayTime, function(_) {
                    hide();
                });
            }
        });

        trace('postShoot | $iNum');
    }

    private function hide():Void {
        trace('hiding');
        FlxTween.cancelTweensOf(troubleShooter);
        FlxTween.tween(troubleShooter, {x: -troubleBg.width - 20, alpha: 0}, 0.5, {
            ease: FlxEase.quadIn,
            onComplete: (_) -> {
                troubleShooter.alpha = 0;
                trace('hidden');
            }
        });
    }
}
