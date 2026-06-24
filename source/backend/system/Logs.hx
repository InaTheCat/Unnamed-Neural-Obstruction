package backend.system;

using StringTools;

class Logs {
    public static function send(msg:Dynamic, ?type:String = 'Info', ?shooterTime:Float = 2) {
        switch(type){
            case 'Info':
				FlxG.log.notice('[${type.replace('\n', ' ')}] | ${Std.string(msg)}');
            case 'Warning':
				FlxG.log.warn('[${type.replace('\n', ' ')}] | ${Std.string(msg)}');
            case 'Error':
				FlxG.log.warn('[${type.replace('\n', ' ')}] | ${Std.string(msg)}');
            default:
				trace('[${type.replace('\n', ' ')}] | ${Std.string(msg)}');
        }

        TroubleShooter.instance.send(msg, type ?? 'Info', shooterTime ?? 2);
    }
}