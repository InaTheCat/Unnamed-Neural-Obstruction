package game;

import flixel.FlxG;

class Controls {
    public static var common(get, never):Bool;
    public static var common_p(get, never):Bool;
    public static var common_r(get, never):Bool;

    public static var left(get, never):Bool;
    public static var left_p(get, never):Bool;
    public static var left_r(get, never):Bool;

    public static var down(get, never):Bool;
    public static var down_p(get, never):Bool;
    public static var down_r(get, never):Bool;

    public static var up(get, never):Bool;
    public static var up_p(get, never):Bool;
    public static var up_r(get, never):Bool;

    public static var right(get, never):Bool;
    public static var right_p(get, never):Bool;
    public static var right_r(get, never):Bool;

    public static function get_left():Bool return FlxG.keys.justPressed.Q;
    public static function get_left_p():Bool return FlxG.keys.pressed.Q;
    public static function get_left_r():Bool return FlxG.keys.justReleased.Q;

    public static function get_down():Bool return FlxG.keys.justPressed.W;
    public static function get_down_p():Bool return FlxG.keys.pressed.W;
    public static function get_down_r():Bool return FlxG.keys.justReleased.W;

    public static function get_up():Bool return FlxG.keys.justPressed.O;
    public static function get_up_p():Bool return FlxG.keys.pressed.O;
    public static function get_up_r():Bool return FlxG.keys.justReleased.O;

    public static function get_right():Bool return FlxG.keys.justPressed.P;
    public static function get_right_p():Bool return FlxG.keys.pressed.P;
    public static function get_right_r():Bool return FlxG.keys.justReleased.P;

    public static function get_common():Bool
        return FlxG.keys.justPressed.Q
        || FlxG.keys.justPressed.W
        || FlxG.keys.justPressed.O
        || FlxG.keys.justPressed.P;

    public static function get_common_p():Bool
        return FlxG.keys.pressed.Q
        || FlxG.keys.pressed.W
        || FlxG.keys.pressed.O
        || FlxG.keys.pressed.P;

    public static function get_common_r():Bool
        return FlxG.keys.justReleased.Q
        || FlxG.keys.justReleased.W
        || FlxG.keys.justReleased.O
        || FlxG.keys.justReleased.P;

    /**
     * Get key state for a direction.
     * @param direction Direction of the note from 0 to 3 (common FNF order duh).
     * @return Whether the key was just pressed
     */
    public static function getKeyPressed(direction:Int):Bool {
        return switch(direction) {
            case 0: left;
            case 1: down;
            case 2: up;
            case 3: right;
            default: false;
        }
    }

    /**
     * Get key held state for a direction.
     * @param direction Direction of the note from 0 to 3 (common FNF order duh).
     * @return Whether the key is being held
     */
    public static function getKeyHeld(direction:Int):Bool {
        return switch(direction) {
            case 0: left_p;
            case 1: down_p;
            case 2: up_p;
            case 3: right_p;
            default: false;
        }
    }

    /**
     * Get key released state for a direction.
     * @param direction Direction of the note from 0 to 3 (common FNF order duh).
     * @return Whether the key was just released
     */
    public static function getKeyReleased(direction:Int):Bool {
        return switch(direction) {
            case 0: left_r;
            case 1: down_r;
            case 2: up_r;
            case 3: right_r;
            default: false;
        }
    }
}