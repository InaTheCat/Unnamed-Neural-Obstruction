package backend;

import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;

class CrashLogger {
    static final LOG_DIR = "logs";
    static final LOG_FILE = 'crash-${Date.now().toString()}.log';

    public static function init():Void {
        #if sys
        openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
            UncaughtErrorEvent.UNCAUGHT_ERROR,
            onCrash
        );
        #end
    }

    static function onCrash(e:UncaughtErrorEvent):Void {
        var message = buildReport(e.error);
        saveLog(message);

        lime.app.Application.current.window.alert(
            'Game crashed YOOOOOOOOOOOOO WSPPPPPPPPPPPP\nThe log was saved in: $LOG_DIR/$LOG_FILE',
            "Error"
        );
    }

    static function buildReport(error:Dynamic):String {
        var lines = [];
        lines.push("=== CRASH REPORT ===");
        lines.push("Date: " + Date.now().toString());
        lines.push("Error: " + Std.string(error));
        lines.push("");
        lines.push("--- Call Stack ---");
        
        for (item in CallStack.exceptionStack()) {
            lines.push(stackItemToString(item));
        }

        lines.push("");
        lines.push("--- Haxe Stack ---");
        for (item in CallStack.callStack()) {
            lines.push(stackItemToString(item));
        }

        return lines.join("\n");
    }

    static function stackItemToString(item:StackItem):String {
        return switch (item) {
            case FilePos(s, file, line, col): '$file:$line';
            case CFunction: "C Function";
            case Module(m): 'Module($m)';
            case Method(cls, method): '$cls.$method';
            case LocalFunction(n): 'LocalFunction($n)';
        }
    }

    static function saveLog(content:String):Void {
        try {
            if (!FileSystem.exists(LOG_DIR))
                FileSystem.createDirectory(LOG_DIR);

            File.saveContent(LOG_DIR + "/" + LOG_FILE, content);
        } catch (e:Dynamic) {
            trace('Couldn\'t save crash log: $e');
        }
    }
}