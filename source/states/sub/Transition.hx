package states.sub;

import flixel.FlxSubState;

class Transition extends FlxSubState {
    public var sprite:FlxSprite = null;

    var transCam:FlxCamera = new FlxCamera();

    override public function create() {
        super.create();

        FlxG.cameras.add(transCam, false).bgColor = 0xFF000000;

        add(sprite = new FlxSprite().loadGraphic(Paths.image('menus/transition'))).camera = transCam;
        sprite.scale.x = FlxG.width;
        sprite.updateHitbox();
        sprite.y = -sprite.height;

        FlxTween.tween(sprite, {y: 0}, 0.5);
    }
}