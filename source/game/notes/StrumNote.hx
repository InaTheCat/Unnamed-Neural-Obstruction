package game.notes;

import flixel.math.FlxPoint;

class StrumNote extends FlxSpriteGroup {
    var center:FlxPoint = FlxPoint.get();

    public var note:FlxSprite;
    public var receptor:FlxSprite;
    public var splash:FlxSprite;

    public function new(x:Int = 0, y:Int = 0, dir:Int = 0) {
        dir %= 4;

        super();

        add(note = new FlxSprite(0, 0));
        note.frames = Paths.getSparrowAtlas('game/notes/default');
        note.animation.addByPrefix('static', getDir(dir), 0, false);
        note.animation.addByPrefix('press', getDir(dir, true) + ' press', 24, false);
        note.animation.play('static');
        note.scale.set(0.7, 0.7);
        note.updateHitbox();

        setPosition(x, y);
    }

    public function playAnim(anim:String, force:Bool = false) {
        center.set(note.x + note.width / 2, note.y + note.height / 2);

        note.animation.play(note.animation.exists(anim) ? anim : 'static', force);
        note.updateHitbox();

        note.setPosition(center.x - note.width / 2, center.y - note.height / 2);

        note.centerOffsets();

        center.put();
    }

    public function getDir(dir:Int = 0, alt:Bool = false):String
        switch(dir){
            case 0: return alt ? 'left' : 'arrowLEFT';
            case 1: return alt ? 'down' : 'arrowDOWN';
            case 2: return alt ? 'up' : 'arrowUP';
            case 3: return alt ? 'right' : 'arrowRIGHT';
            default: return alt ? 'left' : 'arrowLEFT';
        }
}