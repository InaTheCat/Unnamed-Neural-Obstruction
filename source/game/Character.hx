package game;

import flixel.FlxSprite;
import flixel.util.typeLimit.OneOfTwo;
import utils.Paths;

class Character extends FlxSprite {
    public var sprite:String = null;
    public var isPlayer:Bool = false;

	public var bfOffsets:Map<String, Array<Float>>=[
        'idle' => [-5, 0],
        'singLEFT' => [6, -7],
        'singDOWN' => [-17, -50],
        'singUP' => [-36, 27],
        'singRIGHT' => [-48, -6]
    ];

    public var dadOffsets:Map<String, Array<Float>>=[
        'idle' => [0, 0],
        'singLEFT' => [-4, 26],
        'singDOWN' => [2, -31],
        'singUP' => [-10, 50],
        'singRIGHT' => [-4, 26]
    ];

    public function new(x:Float = 0, y:Float = 0, img:String = 'characters/bf', ?player:Bool = false) {
        super(x, y);

        isPlayer = player;
        sprite = img;
        prepareAnim();
    }

    private function prepareAnim():Void {
        frames = Paths.getSparrowAtlas(sprite);
        
        animation.addByPrefix('idle', 'idle');
        animation.addByPrefix('singLEFT', 'left', 24, false);
        animation.addByPrefix('singDOWN', 'down', 24, false);
        animation.addByPrefix('singUP', 'up', 24, false);
        animation.addByPrefix('singRIGHT', 'right', 24, false);

        playAnim('idle');
    }

    public function playAnim(animName:String, ?force:Bool = false):Void {
        force ?? false;

        animation.play(animName, force);

        offset.set(isPlayer ? bfOffsets[animName][0] : dadOffsets[animName][0], isPlayer ? bfOffsets[animName][1] : dadOffsets[animName][1]);
    }
}