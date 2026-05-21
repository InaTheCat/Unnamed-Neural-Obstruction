package scripting.psescript;

import backend.TroubleShooter as Shooter;
import flixel.FlxSprite;

/**
 * PscInterpreter
 * 
 * Well, its an interpreter, pretty self descreptive init?
 *
 * If for some reason you wanna add, edit or delete a type, command or function:
 *   1. Go to `scripting.psescript.PscNode;`.
 *   2. Add the parse u want in `scripting.psescript.PscParser;`.
 *   3. And add your thang in `execute() [line 42]`.
 */
class PscInterpreter {

    // Actual script active vars (name -> obj)
    var vars:Map<String, Dynamic> = [];

    // Reference of FlxState/FlxGroup to... add()
    // It recibes as a function for the interpreter of the FlxState. (ion even know what i said)
    var addFn:Dynamic -> Void;

    public function new(addFn:Dynamic -> Void) {
        this.addFn = addFn;
    }

    // ── Starting point ─────────────────────────────────────────────────────

    public function run(nodes:Array<PscNode>) {
        for (node in nodes) {
            execute(node);
        }
    }

    // ── Node execution ───────────────────────────────────────────────────

    function execute(node:PscNode) {
        switch (node) {

            case DeclareVar(name, type):
                declareVar(name, type);

            case SetSprite(varName, imagePath):
                var spr = getSprite(varName);
                if (spr != null) spr.loadGraphic(Paths.image(imagePath));

            case SetPos(varName, x, y):
                var spr = getSprite(varName);
                if (spr != null) spr.setPosition(x, y);

            case SetScale(varName, x, y):
                var spr = getSprite(varName);
                if (spr != null) { spr.scale.set(x, y); spr.updateHitbox(); }

            case SetAlpha(varName, value):
                var spr = getSprite(varName);
                if (spr != null) spr.alpha = value;

            case SetVisible(varName, value):
                var spr = getSprite(varName);
                if (spr != null) spr.visible = value;

            case SetProperty(varName, prop, value):
				// Generic Fallback :sob:
                var obj = vars.get(varName);
                if (obj != null) {
                    try {
                        Reflect.setField(obj, prop, value);
                    } catch (e) {
                        Shooter.instance.send('Could\'nt set $varName.$prop = $value [ERR: $e]', 'PSeError');
                    }
                } else {
                    Shooter.instance.send('Could\'nt find var: "$varName"', 'PSeError');
                }

            case AddToScene(varName):
                var obj = vars.get(varName);
                if (obj != null) addFn(obj);
                else Shooter.instance.send('add(): Could\'nt find var: "$varName"', 'PSeError');

            case Unknown(raw):
                Shooter.instance.send('Line not recognized: "$raw"', 'PSeError');
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    function declareVar(name:String, type:String) {
        var obj:Dynamic = switch (type.toLowerCase()) {
            case "sprite": new FlxSprite();
            default:
                Shooter.instance.send('Unknown type: "$type", will be replaced to "null"', 'PSeWarning');
                null;
        }
        vars.set(name, obj);
    }

    // Return the var as FlxSprite.
    function getSprite(varName:String):FlxSprite {
        var obj = vars.get(varName);
        if (obj == null) {
            Shooter.instance.send('Sprite not found: "$varName"', 'PseError');
            return null;
        }
        if (!Std.isOfType(obj, FlxSprite)) {
            Shooter.instance.send('"$varName" is not an FlxSprite', 'PseError');
            return null;
        }
        return cast obj;
    }
}
