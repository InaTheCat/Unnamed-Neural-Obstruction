import flixel.FlxG;
import flixel.FlxSprite;
import utils.Paths;

var test:FlxSprite;

function create() {
    FlxG.state.add(test = new FlxSprite(400, 250).loadGraphic(Paths.image('osaka')));

    trace('external script');
}