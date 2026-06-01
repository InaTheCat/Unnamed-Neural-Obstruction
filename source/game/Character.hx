package game;

import backend.TroubleShooter;
import flixel.FlxSprite;
import utils.CoolUtil;
import utils.Paths;

typedef CharacterAnim =
{
	var name:String;
	var anim:String;
	@:optional var fps:Int;
	@:optional var loop:Bool;
	@:optional var offset:Array<Float>;
}

typedef CharacterJson =
{
	var path:String;
	var anims:Array<CharacterAnim>;
}

class Character extends FlxSprite {
	var charJson:CharacterJson;

    public var sprite:String = null;
    public var isPlayer:Bool = false;

	public var offsets:Map<String, Array<Float>> = [];

    public var dadOffsets:Map<String, Array<Float>>=[
        'idle' => [0, 0],
        'singLEFT' => [-4, 26],
        'singDOWN' => [2, -31],
        'singUP' => [-10, 50],
        'singRIGHT' => [-4, 26]
    ];

	public function new(x:Float = 0, y:Float = 0, character:String = 'bf', ?player:Bool = false)
	{
        super(x, y);

		charJson = cast CoolUtil.parseJson('data/characters/$character');

		if (charJson == null)
		{
			TroubleShooter.instance.send('charJson failed to load. [$character] | The Character will be\nreplaced for bf', 'Error');
			charJson = cast CoolUtil.parseJson('data/characters/bf');

			if (charJson == null)
			{
				TroubleShooter.instance.send('Not even bf, then it wont fucking gonna appear then', 'Error');
				return;
			}
		}

        isPlayer = player;
		sprite = charJson.path;
        prepareAnim();
    }

    private function prepareAnim():Void {
        frames = Paths.getSparrowAtlas(sprite);
        
		for (e in charJson.anims)
		{
			animation.addByPrefix(e.name, e.anim, e.fps != null ? e.fps : 24, e.loop != null ? e.loop : false);

			offsets.set(e.name, e.offset != null ? e.offset : [0, 0]);
		}

        playAnim('idle');
    }

	public function playAnim(animName:String, ?force:Bool = false):Void
	{
        animation.play(animName, force);
		var animOffsets = offsets.get(animName);

		if (animOffsets != null)
			offset.set(animOffsets[0], animOffsets[1]);
		else
			offset.set();
    }
}