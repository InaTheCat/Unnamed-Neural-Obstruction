package backend.system;

import backend.system.ANSI;

using StringTools;

class Logs {
	public static function send(msg:Any, ?type:String = "Info", ?shooterTime:Float = 2)
	{
		var cleanMsg:String = Std.string(msg).replace("\n", " ");

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

		TroubleShooter.instance.send(msg, type, shooterTime);
    }
}