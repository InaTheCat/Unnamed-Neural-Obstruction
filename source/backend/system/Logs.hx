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

typedef TraceFunction = Dynamic->?haxe.PosInfos->Void;

class Logs
{
	/**
	 * da og trace heh
	**/
	private static var _oTrace:TraceFunction;

	public static var colors:Map<String, Int> = [
		'Debug' => 0x00FF00,
		'Info' => 0x0000FF,
		'Warning' => 0xFFFF00,
		'Error' => 0xFF0000,
		'None' => 0xFFFFFFFF,
		'Trace' => 0xFF000055,
		'Source Info' => 0xAA00FF,
		'PSeScript' => 0xFFAAAAAA,
		'PSeWarning' => 0xFFFFFFAA,
		'PSeError' => 0xFFFF5555
	];

	/**
	 * mmmmh, Logs, like, another trace func ig heh
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
	public static function send(msg:Dynamic, type:LogType = Info)
	{
		var cleanMsg:String = Std.string(msg);

		#if sys
		if (type == Debug)
			Sys.println(ANSI.coloredText('[$type] | $cleanMsg', 'Debug'));
		else
			Sys.println(type.trim() == None ? '${cleanMsg.replace('\n', ' ')}' : '${ANSI.coloredType(type)} | ${cleanMsg.replace('\n', ' ')}');
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
    }
	public static function internal(msg:Dynamic)
	{
		Sys.println('${ANSI.coloredType(SourceInfo)} | ${Std.string(msg).replace('\n', ' ')}');

		#if !FLX_NO_DEBUG
		switch (type)
		{
			case 'Info':
				FlxG.log.notice(cleanMsg);

			case 'Warning':
				FlxG.log.warn(cleanMsg);

			case 'Error':
				FlxG.log.error(cleanMsg);

			default:
				FlxG.log.add(cleanMsg);
		}
		#end
	}
	/**
	 * with ts u call da og trace function (function that got overrided before heh)
	**/
	public static function trace(msg:Dynamic, ?infos:haxe.PosInfos)
		if (_oTrace != null)
			_oTrace(Std.string(msg), infos);
}