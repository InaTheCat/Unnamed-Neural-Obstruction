package backend.ui;

import flixel.group.FlxSpriteContainer;
import flixel.math.FlxPoint;

class Button extends FlxSpriteContainer {
    public var onClick:Void -> Void;

    public var buttonText(get, set):String;
    private var _text:String;

    public var text:FlxText;
    public var bg:FlxSprite;

    function get_buttonText():String
        return _text;

    function set_buttonText(value:String):String {
        if (_text == value)
            return value;

        var center:FlxPoint = FlxPoint.get(bg.x + (text.textField.textWidth / 2) + 15, bg.y + (text.textField.textHeight / 2) + 10);

        text.text = value;

        text.setPosition(center.x, center.y);

        center.put();

        return value;
    }

    public function new(x:Float = 0, y:Float = 0, text:Dynamic = 'No Text', width:Int = 300, height:Int = 150) {
        super(x, y);

        prepareButton(text, width, height);
    }

    public function prepareButton(text:Dynamic, width:Int, height:Int) {
        add(bg = new FlxSprite().makeGraphic(width, height, 0xFFAAAAAA));

        add(text = new FlxText(0, 0, width - 25, Std.string(text)).setFormat(null, 24, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000));

        text.setPosition(bg.x + (text.textField.textWidth / 2) + 15, bg.y + (text.textField.textHeight / 2) + 10);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(bg) && FlxG.mouse.justPressed)
            if (onClick != null)
                onClick();
    }
}