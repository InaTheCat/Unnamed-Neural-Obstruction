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

        switch(dir){
            case 0: animation.addByPrefix('static', 'purple0', 0, false);                
            case 1: animation.addByPrefix('static', 'blue0', 0, false);                
            case 2: animation.addByPrefix('static', 'green0', 0, false);                
            case 3: animation.addByPrefix('static', 'red0', 0, false);                
        }

        animation.play('static');
		scale.set(0.7, 0.7);
		updateHitbox();

        setPosition(x, 0);
    }
}