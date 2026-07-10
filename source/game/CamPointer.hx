package game;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import game.Character;

class CamPointer extends FlxObject {
    public function new(){
        super(0, 0, 1, 1);
    }

    public function updatePos(character:Character) {
        if (character == null){
            Logs.send('Character was null, how tf r u even running the game?', {type: 'Error'});
            return;
        }

        var mid = character.getMidpoint();

        var offsets:FlxPoint = FlxPoint.get(character.camOffset.x ?? 0, character.camOffset.y ?? 0);
        setPosition(mid.x + offsets.x, mid.y + offsets.y);
    }
}