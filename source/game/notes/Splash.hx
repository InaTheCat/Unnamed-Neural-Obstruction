package game.notes;

class Splash extends FlxSprite {
    var splashAlpha:Float = 0.5;

    public function new(x:Float = 0, y:Float = 0, dir:Int = 0, alpha:Float = 0.5) {
        super(x, y);

        splashAlpha = alpha;

        frames = Paths.getSparrowAtlas('game/splashes/default');

        switch (dir) {
            case 0:
                animation.addByPrefix('press1', 'left1', 24, false);
                animation.addByPrefix('press2', 'left2', 24, false);

            case 1:
                animation.addByPrefix('press1', 'down1', 24, false);
                animation.addByPrefix('press2', 'down2', 24, false);

            case 2:
                animation.addByPrefix('press1', 'up1', 24, false);
                animation.addByPrefix('press2', 'up2', 24, false);

            case 3:
                animation.addByPrefix('press1', 'right1', 24, false);
                animation.addByPrefix('press2', 'right2', 24, false);

            default:
                animation.addByPrefix('press1', 'right1', 24, false);
                animation.addByPrefix('press2', 'right2', 24, false);
        }

        this.alpha = 0;

        animation.onFinish.add((n:String) ->
            if (n == 'press1' || n == 'press2')
                this.alpha = 0
        );
    }

    public function press() {
        this.alpha = splashAlpha;

        animation.play('press${FlxG.random.int(1, 2)}', true);
    }

    public function playAnim(anim:String = 'press1', force:Bool = true, asRandom:Bool = false){
        this.alpha = splashAlpha;

        if (asRandom)
            animation.play('press${FlxG.random.int(1, 2)}', force);
        else
            animation.play(anim, force);
    }
}