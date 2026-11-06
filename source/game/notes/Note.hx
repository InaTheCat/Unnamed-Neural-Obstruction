package game.notes;

class Note extends FlxSprite {
    public var strumTime:Float;
    public var dir:Int;

    public var gotHit:Bool = false;

    public function new(x:Float, time:Float, dir:Int) {
        super();

        this.dir = dir %= 4;

        strumTime = time;

        frames = Paths.getSparrowAtlas('game/notes/default');

		animation.addByPrefix('static', '${StrumNote.getDir(dir % 4, true, true)}0', 0, false);                

        animation.play('static');
		scale.set(0.7, 0.7);
		updateHitbox();

        setPosition(x, 0);
    }
}