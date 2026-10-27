package game.notes;

import flixel.math.FlxPoint;

class Splash extends FlxSprite {
    var center:FlxPoint = FlxPoint.get();

    public function new(x:Float = 0, y:Float = 0, dir:Int = 0) {
        dir %= 4;

        super();

        frames = Paths.getSparrowAtlas('game/splashes/default');
        animation.addByPrefix('press1', StrumNote.getDir(dir, true)+'1', 24, false);
        animation.addByPrefix('press2', StrumNote.getDir(dir, true)+'2', 24, false);
        animation.play('press1');

        visible = false;
        alpha = 0.5;

        setPosition(x - 125, y - 100);

        animation.onFinish.add((n:String) -> visible = false);
    }

    public function hit() {
		center.set(x + width / 2, y + height / 2);

        visible = true;
        animation.play('press${FlxG.random.int(1, 2)}', true);

		setPosition(center.x - width / 2, center.y - height / 2);

		centerOffsets();

        center.put();
    }
}