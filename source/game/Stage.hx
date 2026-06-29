package game;

import Sys;
import backend.system.ANSI;
import flixel.util.typeLimit.OneOfTwo;

enum abstract StageObjectType(String)
{
    var Sprite = "sprite";
    var Animated = "animated";
    var Text = "text";
    var Backdrop = "backdrop";
    var Tilemap = "tilemap";
}

typedef ObjectProperties = {
    var pos:Null<Array<Float>>;
    var visible:Null<Bool>;
    var alpha:Null<Float>;
    var angle:Null<Float>;

    var velocityX:Null<Float>;
    var velocityY:Null<Float>;
    var velocity:Null<Array<Float>>;

    var accelerationX:Null<Float>;
    var accelerationY:Null<Float>;
    var acceleration:Null<Array<Float>>;

    var scrollX:Null<Float>;
    var scrollY:Null<Float>;
    var scroll:Null<Float>;

    var scaleX:Null<Float>;
    var scaleY:Null<Float>;
    var scale:Null<Float>;

    var updateHitbox:Null<Bool>;

    var flipX:Null<Bool>;
    var flipY:Null<Bool>;

    var antialiasing:Null<Bool>;

    var blend:Null<String>;

    var color:Null<Int>;

    var originX:Null<Float>;
    var originY:Null<Float>;

    // Backdrop shii
    var repeatX:Null<Bool>;
    var repeatY:Null<Bool>;

    var spacingX:Null<Float>;
    var spacingY:Null<Float>;
}

typedef StageObjects = {
    var type:Null<StageObjectType>;

    var name:Null<String>;
    var sprite:String;

    var addBehind:Null<OneOfTwo<String, Bool>>;
    var addAbove:Null<OneOfTwo<String, Bool>>;

    var prefix:String;
    var loop:Null<Bool>;
    var fps:Null<Int>;

    var properties:Null<ObjectProperties>;
}

typedef StageJson = {
    var path:Null<String>;
    var name:String;
    
    var objects:Null<Array<StageObjects>>;
}

class Stage {
    var JSON:StageJson;

    var stageObjects:Map<String, FlxSprite> = [];

    public function new() {}

    public function startStage(jsonPath:String) {
        if (!Paths.exists('data/stages/$jsonPath.json')){
            Logs.send('${ANSI.coloredType('$jsonPath', 0xFF0055FF)} was\'nt found', 'Error');
            JSON = null;
            return;
        }

        JSON = CoolUtil.parseJson('data/stages/$jsonPath');

        // trace(JSON);

        // setStage(JSON);
    }

    private function setStage(daJson:StageJson) {
        // if (daJson != null) trace(daJson);
    }
}