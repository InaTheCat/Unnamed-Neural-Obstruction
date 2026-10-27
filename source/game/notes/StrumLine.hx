package game.notes;

import game.notes.StrumNote;

class StrumLine extends FlxSpriteContainer {
    public var keyCount:Int = 4;
    public var spacing:Int = 110;

    public function new(x:Float = 0, y:Float = 0, keyCount = 4) {
        super(x, y);

        this.keyCount = keyCount;

        for (i in 0...this.keyCount){
            var note:StrumNote = new StrumNote(i * spacing, 0, i);
            add(note);
        }
    }

    public function playAnim(dir:Int = 0, anim:String, force:Bool = false) {
        dir %= keyCount;

        cast(members[dir], StrumNote).playAnim(anim, force);
    }
}