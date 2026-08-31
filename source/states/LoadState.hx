package states;

import backend.system.SFXBank;
import flixel.FlxState;
import winapi.WindowsAPI;

class LoadState extends FlxState {
	override public function create():Void
	{
		WindowsAPI.reDefineMainWindowTitle(lime.app.Application.current.window.title);
		WindowsAPI.windowDarkMode(true);
		WindowsAPI.setWindowTextColor(200, 200, 200);
		WindowsAPI.centerWindow();

        super.create();

		Options.init();
		SFXBank.init();

		#if !FLX_NO_DEBUG FlxG.debugger.visible = true; #end

		haxe.Log.trace = (v:Dynamic, ?infos:haxe.PosInfos) -> Logs.send(v, {type: Trace});

		if (Options.updateWindowsAPI)
			FlxG.signals.postStateSwitch.add(() ->
			{
				if (!Options.updateWindowsAPI)
					FlxG.signals.postStateSwitch.removeAll();

				WindowsAPI.reDefineMainWindowTitle(lime.app.Application.current.window.title);
			});

		FlxG.switchState(() -> new TitleState());
    }
}