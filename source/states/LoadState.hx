package states;

import winapi.WindowsAPI;

class LoadState extends FlxState
{
	override public function create()
	{
		WindowsAPI.reDefineMainWindowTitle(lime.app.Application.current.window.title);
		WindowsAPI.windowDarkMode(true);
		WindowsAPI.centerWindow();

        super.create();

		@:privateAccess
		Logs._oTrace = haxe.Log.trace;

		haxe.Log.trace = (v:Dynamic, ?infos:haxe.PosInfos) -> Logs.send(v, Trace);

		FlxG.switchState(() -> new PlayState());
    }
}