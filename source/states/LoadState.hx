package states;

import flixel.FlxState;
import options.Options;
import utils.WinUtils;
import winapi.WindowsAPI;

class LoadState extends FlxState {
    override function create():Void {
		winapi.WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
		WindowsAPI.windowDarkMode(true);
		WindowsAPI.setWindowTextColor(200, 200, 200);
		WindowsAPI.centerWindow();

        super.create();

		Options.init();

		FlxG.plugins.addPlugin(new TroubleShooter());

		#if !FLX_NO_DEBUG FlxG.debugger.visible = true; #end

		haxe.Log.trace = (v:Dynamic, ?infos:haxe.PosInfos) -> Logs.send(v, 'Trace');

		FlxG.switchState(() -> new states.PlayState());
    }
}