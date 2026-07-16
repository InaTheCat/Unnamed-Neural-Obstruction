package game;

class Alphabet extends FlxSpriteGroup {
    public var text:String = '';

    public function new(x:Float = 0, y:Float, text:String):Void {
       this.text = text;
       
       prepareAlphabet(x, y, text);
    }

    function prepareAlphabet(x:Float, y:Float, text:String):Void {
        var daText:Array<String> = [];

        for (e in daText){
            // var letter:FlxSprite = recycle(FlxSprite);

             
        }
    }
}