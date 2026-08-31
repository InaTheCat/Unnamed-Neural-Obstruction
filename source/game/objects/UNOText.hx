package game.objects;

import flixel.FlxObject;
import flixel.math.FlxPoint;

using StringTools;

typedef FormatSettings = {
    ?size:Int,
    ?font:String,
    ?width:Float,
    ?color:FlxColor,
    ?alignment:FlxTextAlign,
    ?borderStyle:FlxTextBorderStyle,
    ?borderColor:FlxColor
}

class UNOText extends FlxText {
	public var isAttached:Bool = false;
	public var attachedObject:FlxObject = null;
	public var attachedObject2:FlxObject = null;
	public var attachOffset:FlxPoint;

    public function new(x:Float, y:Float, text:Dynamic, ?settings:FormatSettings) {
        var wdt:Float = 0;

        if (settings != null)
            wdt = settings.width ?? 0;

        super(x, y, wdt, Std.string(text));

        if (settings != null){
            setFormat(settings.font != null ? Paths.font(settings.font) : null,
                      settings.size ?? 32,
                      settings.color ?? 0xFFFFFFFF,
                      settings.alignment ?? CENTER,
                      settings.borderStyle ?? NONE,
                      settings.borderColor ?? 0xFF000000
                     );
        }
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

	// also not made heh
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

		if (attachOffset != null){
			attachOffset.put();
			attachOffset = null;
		}
	}
}