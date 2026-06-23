// package system;

// @:buildXml('
// <target id="haxe">
//     <lib name="psapi.lib"/>
// </target>
// ')
// @:cppFileCode('
// #include <windows.h>
// #include <psapi.h>
// ')

// @:build(backend.macros.FunctionsMergeMacro.build(
// 	[
// 		'winapi.WindowsAPI',
// 		'winapi.gdi.WindowsGDI'
// 	],
// 	[
// 		'allocConsole::showConsole',
// 		'sendWindowsNotification::sendNotification',
// 		'resetWindowsFuncs::reset'
// 	]
// ))
// class DesktopAPI 
// {
// 	@:functionCode('
//     PROCESS_MEMORY_COUNTERS_EX pmc;

//     if (GetProcessMemoryInfo(GetCurrentProcess(), (PROCESS_MEMORY_COUNTERS*) &pmc, sizeof(pmc)))
//         return (double) pmc.PrivateUsage;

//     return 0;
// 	')
// 	public static function getTaskMemory():Null<Float>
// 		return null;
	
// 	public static function setWindowTitle()
// 	{
// 		winapi.WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
// 	}
// }