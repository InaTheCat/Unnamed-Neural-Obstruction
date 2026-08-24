package backend.system;

import backend.system.ANSI;

using StringTools;

enum abstract LogType(String) from String to String
{
	var None = 'None';
	var Debug = 'Debug';
	var Info = 'Info';
	var Warning = 'Warning';
	var Error = 'Error';
	var Trace = 'Trace';
	var SourceInfo = 'Source Info';
	var PSeScript = 'PSeScript';
	var PSeWarning = 'PSeWarning';
	var PSeError = 'PSeError';
}

typedef SendSettings =
{
	/**
	 * da type of the log
	 *
	 * Available types:
	 * - `None`
	 * - `Debug`
	 * - `Info`
	 * - `Warning`
	 * - `Error`
	 * - `Trace`
	 * - `Source Info`
	 * - `PSeScript`
	 * - `PSeWarning`
	 * - `PSeError`
	 */
	@:optional var type:Null<LogType>;
	/**
	 *	`shooterTime`: well, u can guess what it is, DA SA `FLOAT`, but
	 *	for the TroubleShooter, soooo, the time of how much time will be
	 *	the shooter in screen, ig???????????????????????????????????????.
	**/
	@:optional var shooterTime:Null<Float>;
	/**
	 *	`showShooter`: dasa `Bool`, but the Shooter, if true well... u
	 *	can guess it, itll prepare u a sandwich ig.
	**/
	@:optional var showShooter:Null<Bool>;
	/**
	 *	`overrideShooterText`: this is for, uh, exactly what it says,
	 *	the text that u write here will override the shooter one, its
	 *	usable if for some reason u want the message of the Log and the
	 *	TroubleShooter to be different, u can just "override" it with this.
	**/
	@:optional var overrideShooterText:Null<String>;
}

class Logs {
	public static var skipShooter:Bool = false;

	/**
	 * Main function of the Logs class
	 *	 
	 * Literally sends a log/trace/TroubleShoot
	 * 
	 * u can also use trace(), it'll do a Logs.send with the `"Trace"` type
	 *
	 * @param msg
	 *	   well... the message
	 *
	 * @param settings
	 *	   da settings with things as the type of the Log, shooter settings n more
	**/
	public static function send(msg:Dynamic, ?settings:SendSettings)
	{
		var type:String = settings.type ?? 'Info';
		var shooterTime:Float = settings.shooterTime ?? 2;
		var showShooter:Bool = settings.showShooter ?? true;
		var overrideShooterText:String = settings.overrideShooterText ?? null;

		var cleanMsg:String = Std.string(msg);

		#if sys
		if (type == 'Debug')
			Sys.println(ANSI.coloredText('[$type] | $cleanMsg', 'Debug'));
		else
			Sys.println(type.trim() == 'None' ? '${cleanMsg.replace('\n', ' ')}' : '${ANSI.coloredType(type)} | ${cleanMsg.replace('\n', ' ')}');
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

		if (skipShooter)
			return;

		if (showShooter)
			TroubleShooter.instance.send(overrideShooterText == null ? Std.string(msg) : overrideShooterText, type, shooterTime);
    }
}