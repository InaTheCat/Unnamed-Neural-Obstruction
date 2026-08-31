package backend;

import haxe.CallStack;
import lime.app.Application;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CrashLogger
{
	public static function init():Void
	{
	    /**
	     * alejo estuvo aqui asdjladks
	     * 
	     * saludos ina
		 *
		 * 27/08/2026
		 * but sas que le muevo todo de manera inmensa
	     */

		#if sys
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
			UncaughtErrorEvent.UNCAUGHT_ERROR, (error) ->
			{
				var output:String = '\n';
				output += 'UNO Crash Handler\n\n';

				output += 'Error:\n';
				output += '${error.error}\n\n';

				output += '\nException Stack:\n\n';

				for (stackItem in CallStack.exceptionStack(true))
				{
					output += formatStackItem(stackItem) + '\n';
				}

				output += '\n\nCall Stack:\n\n';

				for (stackItem in CallStack.callStack())
				{
					output += formatStackItem(stackItem) + '\n';
				}



				trace(output, 'error');

				Application.current.window.alert(
					output,
					'UNO Crash Handler'
				);

				Sys.exit(1);
			}
		);

		#end
	}

	private static function formatStackItem(item:haxe.CallStack.StackItem):String
	{
		return switch (item)
		{
			case FilePos(inner, file, line, column):
				switch (inner)
				{
					case Method(className, func):
						'$className.$func() - $file : #$line:$column';

					case LocalFunction(func):
						'$func() - $file : #$line:$column';

					default:
						'$file : #$line:$column';
				}

			case Method(className, func):
				'$className.$func()';

			case LocalFunction(func):
				'$func()';

			case CFunction:
				'[C function]';

			case Module(name):
				'Module $name';

			default:
				Std.string(item);
		}
	}

	private static function saveCrashLog(log:String):Void
	{
		#if sys
		if (!Paths.exists('logs'))
		{
			try
			{
				FileSystem.createDirectory('logs');
			}
			catch (e:Dynamic)
			{
				Logs.send('Couldn\'t create Logs folder [$e]', {type: Error, showShooter: false});
				return;
			}
		}

		if (!Paths.exists('logs'))
		{
			Logs.send('Logs folder doesn\'t been created after trying it', {type: Error, showShooter: false});
			return;
		}

		final date:Date = Date.now();

		var year:String = StringTools.lpad(Std.string(date.getFullYear() % 100), '0', 2);
		var month:String = StringTools.lpad(Std.string(date.getMonth() + 1), '0', 2);
		var day:String = StringTools.lpad(Std.string(date.getDate()), '0', 2);

		var hour:String = StringTools.lpad(Std.string(date.getHours()), '0', 2);
		var minute:String = StringTools.lpad(Std.string(date.getMinutes()), '0', 2);
		var second:String = StringTools.lpad(Std.string(date.getSeconds()), '0', 2);

		var milliseconds:String = StringTools.lpad(Std.string(date.getTime() % 1000), '0', 3);

		var fileName:String = '($day-$month-$year) [$hour-$minute-$second.$milliseconds].txt';

		var filePath:String = 'logs/$fileName';

		try
		{
			File.saveContent(filePath, log);
		}
		catch (e:Dynamic)
		{
			Logs.send('Couldn\'t save crash log [$e]', {type: Error, showShooter: false});
			return;
		}

		if (!FileSystem.exists(filePath))
			Logs.send('Crash log couldn\'t be created even after a comprobation, how???? ion really know', {type: Error, showShooter: false});
		#else
		Logs.send('Target isn\'t sys and can\'t save Log', {type: Error, showShooter: false});
		#end
	}
}