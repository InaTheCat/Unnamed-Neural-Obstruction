package states;

import flixel.FlxSprite;
import game.Character;
import game.Controls;
import states.UNOState;
import utils.Paths;

class TitleState extends UNOState {
    var bf:Character;

    override public function create() {
        super.create();

        bf = new Character(0, 0, 'characters/bf');
        add(bf);
        bf.screenCenter();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        if (Controls.left){
            bf.animation.play('singLEFT', true);
            bf.offset.set(6, -7);
        }

        if (Controls.down){
            bf.animation.play('singDOWN', true);
            bf.offset.set(-17, -50);
        }

        if (Controls.up){
            bf.animation.play('singUP', true);
            bf.offset.set(-39, 27);
        }

        if (Controls.right){
            bf.animation.play('singRIGHT', true);
            bf.offset.set(-48, -6);
        }

        
        if (Controls.common)
            bf.animation.onFinish.add((n:String) -> if (n != 'idle') {
                bf.animation.play('idle');
                bf.offset.set(-5, 0);
            });
    }
}