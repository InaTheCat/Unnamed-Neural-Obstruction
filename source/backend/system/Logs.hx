package backend.system;

class Logs {
    public static function send(msg:Dynamic, ?type:String = 'Info', ?shooterTime:Float = 2) {
        switch(type){
            case 'Info':
                FlxG.log.notice('[$type] | $msg');
            case 'Warning':
                FlxG.log.warn('[$type] | $msg');
            case 'Error':
                FlxG.log.warn('[$type] | $msg');
            default:
                trace('[$type] | $msg');
        }

        TroubleShooter.instance.send(msg, type ?? 'Info', shooterTime ?? 2);
    }
}