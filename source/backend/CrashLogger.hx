package backend;

import lime.app.Application;

import haxe.CallStack;
import haxe.io.Path;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CrashLogger
{
    /**
     * alejo estuvo aqui asdjladks
     * 
     * saludos ina
     */

    public static function init():Void
    {
        #if sys
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (error) -> {
			final title:String = 'UNO Crash Handler';

			var printMessage:String = '';

			var consoleMessage:String = '\n' + title + '\n';

			for (stackItem in CallStack.exceptionStack(true))
			{
				switch (stackItem)
				{
					case FilePos(item, file, line, _):
						switch (item)
						{
							case Method(className, func):
								printMessage += className + '.' + func + ' - Line ' + line;
							default:
								printMessage += file + ':' + line;
						}

						printMessage += '\n';

						consoleMessage += file + '#' + line + '\n';
					default:
						Sys.println(stackItem);
				}
			}

			final errorMessage:String = '\n' + error.error;

			trace(consoleMessage + errorMessage, 'error');
			
			Application.current.window.alert(printMessage + errorMessage, title);

			Sys.exit(1);
		});
        #end
    }
}