package game;

typedef CharacterAnim =
{
	var name:String;
	var anim:String;
	var fps:Null<Int>;
	var loop:Null<Bool>;
	var offset:Null<Array<Float>>;
}

typedef CharacterJson =
{
	var holdTime:Null<Float>;
	var path:Null<String>;
	var color:Null<String>;
	var icon:Null<String>;
	var anims:Array<CharacterAnim>;
}

class Character extends FlxSprite {
	var charJson:CharacterJson;
	public var iconColor:FlxColor = 0xFFFFFFFF;

    public var sprite:String = null;
    public var isPlayer:Bool = false;

	public var holdTime:Float = 4;
	public var charTimer:FlxTimer = null;

	public var offsets:Map<String, Array<Float>> = [];

	/**
	 * @param x why would i need to write this?
	 * @param y same with `x`
	 * @param character The json name, heh
	 * @param player what do you think it does gng
	**/
	public function new(x:Float = 0, y:Float = 0, character:String = 'bf', ?player:Bool = false)
	{
        super(x, y);

		charJson = cast CoolUtil.parseJson('data/characters/$character');

		if (charJson == null)
		{
			Logs.send('charJson failed to load. [$character] | The Character will be\nreplaced for bf', 'Warning');
			charJson = cast CoolUtil.parseJson('data/characters/bf');

			if (charJson == null)
			{
				Logs.send('Not even bf, then it wont fucking gonna appear then', 'Error');
				return;
			}
		}

		holdTime = charJson.holdTime ?? 4;
		charTimer = new FlxTimer();

		iconColor = charJson.color != null ? FlxColor.fromString(charJson.color) : 0xFFFFFFFF;
        isPlayer = player;
		sprite = charJson.path;
        prepareAnim();
    }

	private function prepareAnim():Void
	{
		frames = Paths.getSparrowAtlas(sprite);
	
		for (e in charJson.anims)
		{
			animation.addByPrefix(e.name, e.anim, e.fps != null ? e.fps : 24, e.loop != null ? e.loop : false);

			var added = animation.getByName(e.name);
			if (added == null || added.frames.length == 0)
			{
				Logs.send('Anim "${e.name}" (prefix "${e.anim}") doesn\'t have frames. Check the XML', 'Error');
			}
		
			offsets.set(e.name, e.offset != null ? e.offset : [0, 0]);
		}

		dance(true);
	}

	/**
	 * plays the uhm, anim of the char, and thats it
	 * @param animName self descreptive cuh
	 * @param force also self descreptive
	 * @param lock if true, the char wont gonna return to idle
	**/
	public function playAnim(animName:String, ?force:Bool = false, ?lock:Bool = false):Void
	{
        animation.play(animName, force);
		var animOffsets = offsets.get(animName);

		offset.set(animOffsets != null ? animOffsets[0] : 0, animOffsets != null ? animOffsets[1] : 0);

		if (!lock && animName != 'idle')
		{
			if (charTimer != null)
				charTimer.cancel();

			charTimer.start(holdTime / 7, (_:FlxTimer) -> dance(true));
		}
    }
	/**
	 * @return well, whatcha think it'll going to return gng, fucking Icon Color
	**/
	public function getColor():FlxColor
	{
		if (charJson == null || charJson.color == null)
		{
			var shii:String = 'json';
			if (charJson.color == null)
				shii = 'Icon color';

			Logs.send('$shii is null gng', 'Error');
			return 0xFFFFFFFF;
		}

		return iconColor;
	}
	public function dance(?force:Bool = false)
	{
		if (force)
			playAnim('idle', true)
		else
		{
			if (this.animation?.curAnim?.name == 'idle')
				playAnim('idle');
		}
	}
}