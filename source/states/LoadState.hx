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

		FlxG.switchState(() -> new states.PlayState());
    }
}