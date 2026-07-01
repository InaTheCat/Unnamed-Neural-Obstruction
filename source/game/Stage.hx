package game;

import Sys;
import backend.system.ANSI;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import flixel.util.typeLimit.OneOfFour;
import flixel.util.typeLimit.OneOfTwo;
import openfl.display.BlendMode;

using StringTools;

enum abstract StageObjectType(String)
{
	var Sprite = 'sprite';
	var Animated = 'animated';
	var Text = 'text';
	var Backdrop = 'backdrop';
	var Solid = 'solid';
}

typedef ObjectProperties = {
    var pos:Null<Array<Float>>;
    var visible:Null<Bool>;
    var alpha:Null<Float>;
    var angle:Null<Float>;

    var velocityX:Null<Float>;
    var velocityY:Null<Float>;
    var velocity:Null<Array<Float>>;

    var accelerationX:Null<Float>;
    var accelerationY:Null<Float>;
    var acceleration:Null<Array<Float>>;

    var scrollX:Null<Float>;
    var scrollY:Null<Float>;
    var scroll:Null<Float>;

    var scaleX:Null<Float>;
    var scaleY:Null<Float>;
	var scale:Null<Array<Float>>;

    var updateHitbox:Null<Bool>;

    var flipX:Null<Bool>;
    var flipY:Null<Bool>;

    var antialiasing:Null<Bool>;

    var blend:Null<String>;

	var color:Null<String>;

    var originX:Null<Float>;
    var originY:Null<Float>;

	/**
	 * for backdrops muejejjeje
	**/
    var repeatX:Null<Bool>;
    var repeatY:Null<Bool>;

    var spacingX:Null<Float>;
    var spacingY:Null<Float>;
	/**
	 * for Solid thangs... ye, only the size
	**/
	var sizeX:Null<Int>;

	var sizeY:Null<Int>;
	var size:Null<Array<Float>>;
}

typedef StageObjects = {
    var type:Null<StageObjectType>;

    var name:Null<String>;
    var sprite:String;

    var addBehind:Null<OneOfTwo<String, Bool>>;
    var addAbove:Null<OneOfTwo<String, Bool>>;

    var prefix:String;
    var loop:Null<Bool>;
    var fps:Null<Int>;

    var properties:Null<ObjectProperties>;
}

typedef StageJson = {
    var path:Null<String>;
    var name:String;
    
    var objects:Null<Array<StageObjects>>;
}

class Stage {
	public var JSON:StageJson;

	public var stageObjects:Map<String, FlxSprite> = [];

	public var path:String = '';
	public var name:String = '';

	public function new() {} // miku needed to win, si, si me arde, y un chingo

	public function startStage(jsonName:String):Void
	{
		if (!Paths.exists('data/stages/$jsonName.json'))
		{
			Logs.send('${ANSI.coloredType('$jsonName', 0xFF0055FF)} was\'nt found', 'Error');
            JSON = null;
            return;
        }

		JSON = CoolUtil.parseJson('data/stages/$jsonName');

		setStage();
	}

	private function setStage():Void
	{
		if (JSON == null)
		{
			Logs.send('Json is null, please check if you writted the stage correctly');
			return;
		}

		path = JSON.path ?? '';
		name = JSON.name ?? '';

		for (e in JSON.objects)
		{
			var sprite:Dynamic;

			// var sprite:OneOfTwo<OneOfFour<Int, Float, Bool, Array<OneOfTwo<Int, Float>>>, OneOfFour<FlxSprite, FlxBackdrop, FlxText, FlxPieDial>>;

			var type:String = '';

			switch (e.type)
			{
				case Sprite, null:
					sprite = new FlxSprite(e.properties.pos[0] ?? 0, e.properties.pos[1] ?? 0).loadGraphic(Paths.image(e.sprite));

					type = 'sprite';

				case Backdrop:
					var repeats = switch ([e.properties.repeatX, e.properties.repeatY])
					{
						case [true, true]: XY;
						case [true, false]: X;
						case [false, true]: Y;
						default: NONE;
					}

					sprite = new FlxBackdrop(Paths.image(e.sprite), repeats ?? XY, e.properties.spacingX ?? 0, e.properties.spacingY ?? 0);
					type = 'backdrop';

				case Solid:
					sprite = new FlxSprite(e.properties.pos[0] ?? 0, e.properties.pos[1] ?? 0);
					graphicSize(sprite);
					type = 'solid';

				default:
					sprite = new FlxSprite(e.properties.pos[0] ?? 0, e.properties.pos[1] ?? 0).loadGraphic(Paths.image(e.sprite));
					type = 'sprite';
			}

			sprite.alpha = e.properties.alpha ?? 1;
			sprite.angle = e.properties.angle ?? 0;
			sprite.flipX = e.properties.flipX ?? false;
			sprite.flipY = e.properties.flipY ?? false;
			sprite.antialiasing = e.properties.antialiasing ?? false; // Options.antialiasing depois

			setColor(sprite, e.properties.color ?? '0xFFFFFFFF');
			setAcceleration(sprite);
			setVelocity(sprite);
			setScale(sprite, e.properties.updateHitbox ?? false);
		}
	}

	private function setColor(sprite:Dynamic, requested:String):Void
	{
		for (e in JSON.objects)
			if (e.properties.color == null)
				return;

		final REG = ~/^(#|0[xX])([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$/;

		if (!REG.match(requested))
		{
			Logs.send('Invalid color [$requested]', 'Error');
			return;
		}

		var color = requested;

		if (color.startsWith('#'))
			color = '0x' + color.substr(1);

		sprite.color = Std.parseInt(color);
	}

	private function graphicSize(sprite:Dynamic)
	{
		for (e in JSON.objects)
		{
			if (e.properties.size == null && e.properties.sizeX == null && e.properties.sizeY == null)
				return;

			if (e.properties.size == null && (e.properties.sizeX != null || e.properties.sizeY != null))
				sprite.makeGraphic(e.properties.sizeX ?? 25, e.properties.sizeY ?? 25);
			else
				sprite.makeGraphic(e.properties.size[0] ?? 25, e.properties.size[1] ?? 25);
		}
	}

	private function setAcceleration(sprite:Dynamic):Void
	{
		for (e in JSON.objects)
		{
			if (e.properties.acceleration == null && e.properties.accelerationX == null && e.properties.accelerationY == null)
				return;

			if (e.properties.acceleration == null && (e.properties.accelerationX != null || e.properties.accelerationY != null))
			{
				sprite.acceleration.x = e.properties.accelerationX ?? 0;
				sprite.acceleration.y = e.properties.accelerationY ?? 0;
			}
			else
				sprite.acceleration.set(e.properties.acceleration[0] ?? 0, e.properties.acceleration[1] ?? 0);
		}
	}

	private function setVelocity(sprite:Dynamic):Void
	{
		for (e in JSON.objects)
		{
			if (e.properties.velocity == null && e.properties.velocityX == null && e.properties.velocityY == null)
				return;

			if (e.properties.velocity == null && (e.properties.velocityX != null || e.properties.velocityY != null))
			{
				sprite.velocity.x = e.properties.velocityX ?? 0;
				sprite.velocity.y = e.properties.velocityY ?? 0;
			}
			else
				sprite.velocity.set(e.properties.velocity[0] ?? 0, e.properties.velocity[1] ?? 0);
		}
	}

	private function setScale(sprite:Dynamic, updateHitbox:Null<Bool>):Void
	{
		for (e in JSON.objects)
		{
			if (e.properties.scale == null && e.properties.scaleX == null && e.properties.scaleY == null)
				return;

			if (e.properties.scale == null && (e.properties.scaleX != null || e.properties.scaleY != null))
			{
				sprite.scale.x = e.properties.scaleX ?? 0;
				sprite.scale.y = e.properties.scaleY ?? 0;
			}
			else
				sprite.scale.set(e.properties.scale[0] ?? 0, e.properties.scale[1] ?? 0);

			if (updateHitbox && sprite is FlxSprite)
				sprite.updateHitbox();
		}
    }
}