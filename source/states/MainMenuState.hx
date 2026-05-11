package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import game.Controls;
import states.UNOState;
import utils.Paths;

class MainMenuState extends UNOState {
    var buttons:Array<FlxSprite>=[];
    var curSelected:Int = 0;

    var bg:FlxSprite;
    var followShii:FlxObject;

    override public function create():Void {
        super.create();

        bg = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBG'));
        add(bg);

    	bg.scrollFactor.set(0, 0.18);
    	bg.scale.set(1.15, 1.15);
    	bg.updateHitbox();
    	bg.screenCenter();
    	bg.antialiasing = true;

        followShii = new FlxObject(0, 0, 1, 1);
        add(followShii);

    	for (i => e in ['story mode', 'freeplay', 'options', 'credits']){
    		var btn = new FlxSprite(0, 60 + (i * 160));
    		add(btn);
            btn.frames = Paths.getSparrowAtlas('menus/mainmenu/'+e);
    		btn.animation.addByPrefix('i', e+' basic');
    		btn.animation.addByPrefix('s', e+' white');
    		btn.animation.play('i');

    		btn.screenCenter(X);
    		btn.scrollFactor.set();
    		btn.antialiasing = true;
    		buttons.push(btn);
    	}

    	FlxG.camera.follow(followShii, null, 0.06);
    	FlxG.camera.snapToTarget();
    	changeItem();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

    	if (Controls.up || Controls.down || FlxG.mouse.wheel != 0)
    		changeItem((Controls.up ? -1 : 0) + (Controls.down ? 1 : 0) - FlxG.mouse.wheel);
    }

    function changeItem(?mh:Int = 0){
        curSelected += (mh ?? 0);

        if (curSelected < 0) curSelected = buttons.length - 1;
        if (curSelected >= buttons.length) curSelected = 0;

        for (i => e in buttons) {
            e.animation.play(curSelected == i ? 's' : 'i');

            e.updateHitbox();
            e.centerOffsets();
    		e.screenCenter(X);

    		if (curSelected == i){
    			var mid = e.getGraphicMidpoint();
    			followShii.setPosition(mid.x, mid.y);
    			mid.put();
    		}
        }
    }
}