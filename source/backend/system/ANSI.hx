package backend.system;

class ANSI {
    public static inline var RESET = "\x1b[0m";

    public static inline function fromRGB(r:Int, g:Int, b:Int):String {
        return '\x1b[38;2;$r;$g;$b';
    }

    public static function fromHex(color:Int):String {
        var r = (color >> 16) & 0xFF;
        var g = (color >> 8) & 0xFF;
        var b = color & 0xFF;

        return '\x1b[38;2;${r};${g};${b}m';
    }

    public static function coloredType(type:String):String {
        if (type == 'None') return '';

        var shooterColor:Int = TroubleShooter.instance.typeColors.get(type) ?? 0xFFFFFFFF;

        return '${fromHex(shooterColor)}[$type]$RESET';
    }
}