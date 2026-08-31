package game.objects;

import flixel.FlxObject;
import flixel.math.FlxPoint;

using StringTools;

typedef SpriteSettings = {
    /**
     * Types:
     *
     * `Animated`:
     * - anim
     * - animation
     * - animated
     *
     * `Graphic`:
     * - graphic
     * - solid
     *
     * If u only want an image, then, dont set a type or simply set "null",
     * also, yea, `Animated` has 3 texts and `Graphic` has 2, mostly if...
     * ion know, u forgot one, then, u have another one, or simply cuz one
     * is shorter that the other so, yea
    **/
	?type:String,

	?flipX:Bool,
	?flipY:Bool,

    // if graphic
	?width:Int,
	?height:Int,
	?color:Int,

    // if anim
	?anims:Array<String>,
	?fps:Int,
	?loop:Bool
}

class UNOSprite extends FlxSprite {
	public var isAttached:Bool = false;
	public var attachedObject:FlxObject = null;
	public var attachedObject2:FlxObject = null;
	public var attachOffset:FlxPoint;

    public var imagePath:String;
    public var xmlPath:String = null;

    public var hasDanceSides(default, null):Bool = false;
    private var danceStance:Bool = false;

    public var animNotFound(default, null):Bool = false;

    public function new(x:Float, y:Float, image:String, ?settings:SpriteSettings) {
        super(x, y);

        if (settings != null){
            switch (settings.type?.toLowerCase()) {
                case 'anim', 'animation', 'animated':
                    frames = Paths.getSparrowAtlas(image);

                    imagePath = Paths.image(image);
                    xmlPath = Paths.xml(image);

                    if (settings.anims != null){
                        for (e in settings.anims){
                            if (animNotFound) continue;

                            var anim:String = getStartupAnim(e);
                            var fps:Int = settings.fps != null ? settings.fps : 24;
                            var loop:Bool = settings.loop != null ? settings.loop : true;

                            animation.addByPrefix(anim, anim, fps, loop);
                        }

                        hasDanceSides = animation.exists('danceLeft') && animation.exists('danceRight');
                    }

                case 'graphic', 'solid':
					var size:FlxPoint = FlxPoint.get(settings?.width ?? 50, settings?.height ?? 50);

                    makeGraphic(Std.int(size.x), Std.int(size.y), settings.color != null ? settings.color : 0xFFFFFFFF);

                    size.put();

                default:
					loadGraphic(Paths.image(image));
			}

            var type:String = settings.type.toLowerCase();

			if (type != 'graphic' && type != 'solid')
                color = settings.color != null ? settings.color : 0xFFFFFFFF;

            if (settings.flipX != null)
                flipX = settings.flipX;

            if (settings.flipY != null)
                flipY = settings.flipY;
		}
		else
			loadGraphic(Paths.image(image));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (isAttached)
		{
			if (attachedObject != null)
				this.setPosition(attachedObject?.x + (attachOffset?.x ?? 0), attachedObject?.y + (attachOffset?.y ?? 0));
			else
			{
				Logs.send('Tried to attach the object, but uhhhh, the object was null gng', {type: Error});
				isAttached = false;
				return;
			}
		}
	}

    private function getStartupAnim(?anims:String):Null<String>
    {
        if (anims != null)
            return anims;
    
        var anims:Array<String> = animation.getNameList();

        for (e in anims)
            if (e.contains('idle'))
                return 'idle';

        animNotFound = true;

        return anims.length > 0 ? anims[0] : null;
    }

	// still not made heh
	// public function attachTwoPoints(object1:FlxBasic, object2:FlxBasic, ?offsets:{x:Float, y:Float}) {}

	public function attachTo(object:FlxObject, ?offsets:{?x:Float, ?y:Float})
	{
		if (object == null)
		{
			Logs.send('Object supposed to attach is null', {type: Warning});
			return;
		}

		if (attachOffset != null)
			attachOffset.put();

		attachOffset = FlxPoint.get(offsets?.x ?? 0, offsets?.y ?? 0);
		attachedObject = object;
		isAttached = true;
	}

	public function deAttachAll():Void
	{
		if (!isAttached)
		{
			Logs.send('This isn\'t attached to something', {type: Warning});
			return;
		}

		isAttached = false;
		attachedObject = null;

		if (attachedObject2 != null)
			attachedObject2 = null;

		attachOffset.set(0, 0);

		if (attachOffset != null)
		{
			attachOffset.put();
			attachOffset = null;
		}
	}

    /**
     * lil bit (it is) NOT FUCKING USEFUL, but im lazy
    **/
    public function playAnim(anim:String = '', force:Bool = false) {
        if (anim.trim() == '' || anim == null) return;

        animation.play(anim, force);
    }

    public function bump() {
        if (hasDanceSides){
            danceStance = !danceStance;

            animation.play(danceStance ? 'danceLeft' : 'danceRight', true);
        } else {
            if (animation.exists('idle')){
                animation.play('idle', true);
                return;
            }

            if (animation.exists('bump')){
                animation.play('bump', true);
                return;
            }

            var anims:Array<String> = animation.getNameList();
            animation.play(anims.length > 0 ? anims[0] : null);
        }
    }
}