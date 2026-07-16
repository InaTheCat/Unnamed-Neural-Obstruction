package backend.system;

import backend.system.ANSI;

using StringTools;

typedef SendSettings =
{
	@:optional var type:Null<String>;
	@:optional var shooterTime:Null<Float>;
	@:optional var showShooter:Null<Bool>;
	@:optional var overrideShooterText:Null<String>;
}

class Logs {
	public static function send(msg:Dynamic, ?extraSettings:SendSettings)
	{
		var type:String = extraSettings.type ?? 'Info';
		var shooterTime:Float = extraSettings.shooterTime ?? 2;
		var showShooter:Bool = extraSettings.showShooter ?? true;
		var overrideShooterText:String = extraSettings.overrideShooterText ?? null;

		var cleanMsg:String = Std.string(msg);

		#if sys
		Sys.println(type.trim() == 'None' ? '${Std.string(cleanMsg)}' : '${ANSI.coloredType(type)} | ${Std.string(cleanMsg)}');
		#end

		#if !FLX_NO_DEBUG
		switch (type)
		{
			case "Info":
				FlxG.log.notice(cleanMsg);

			case "Warning":
				FlxG.log.warn(cleanMsg);

			case "Error":
				FlxG.log.error(cleanMsg);

            default:
				FlxG.log.add(cleanMsg);
        }
		#end

		if (showShooter)
			TroubleShooter.instance.send(overrideShooterText == null ? msg : overrideShooterText, type, shooterTime);
    }
}