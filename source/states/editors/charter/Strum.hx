/**
 * This... doesnt really work for what was intended rn
 * it was for that fucking strums being lighten but... heh,
 * they crash
**/

package states.editors.charter;

import flixel.math.FlxPoint;

typedef Notes = {
    var note:FlxSprite;
    var dir:Int;
}

class Strum extends FlxSpriteGroup {
    public var receptors:FlxSpriteGroup;

    public var strum:Array<FlxSprite>;

    public function new(x:Float, y:Float, ?scale:Float) {
        super();

        strum = [];

        initStrum(x, y, scale ?? 0.7);
    }

    private function initStrum(x:Float, y:Float, ?scale:Float) {
        add(receptors = new FlxSpriteGroup());

        for (i in 0...4){
            var note:FlxSprite = new FlxSprite();

            note.frames = Paths.getSparrowAtlas('editors/charter/strumLine');

            switch (i){
                case 0:
                    note.animation.addByPrefix('static', Std.string(i), 0, false);
                    note.animation.addByPrefix('light', 'p$i', 24, false);

                case 1:
                    note.animation.addByPrefix('static', Std.string(i), 0, false);
                    note.animation.addByPrefix('light', 'p$i', 24, false);

                case 2:
                    note.animation.addByPrefix('static', Std.string(i), 0, false);
                    note.animation.addByPrefix('light', 'p$i', 24, false);

                case 3:
                    note.animation.addByPrefix('static', Std.string(i), 0, false);
                    note.animation.addByPrefix('light', 'p$i', 24, false);

            }

            note.animation.play('static');

            note.animation.onFinish.add((n:String) -> if (n == 'light') animation.play('static', true));

            note.scale.set(scale, scale);
            note.updateHitbox();
            note.setPosition(x + (i * 109), y);
            note.alpha = 0.5;

            add(note);
            strum.push(note);

            var receptor:FlxSprite = new FlxSprite(note.x, note.y).makeGraphic(Std.int(note.width), 1, 0x50FFFFFF);

            receptors.add(receptor);
        }
    }

    public function anim(dir:Int, force:Bool = false) {
        var note:FlxSprite = strum[dir % 4];
    
        var center:FlxPoint = FlxPoint.get(note.x + note.width / 2, note.y + note.height / 2);
        
        note.animation.play('light', true);
        note.updateHitbox();
        
        note.setPosition(center.x - note.width / 2, center.y - note.height / 2);
        
        note.centerOffsets();
        
        center.put();
    }
}