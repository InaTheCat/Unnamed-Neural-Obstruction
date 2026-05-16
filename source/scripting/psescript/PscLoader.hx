package scripting.psescript;

import sys.FileSystem;
import sys.io.File;

/**
 * PscLoader
 *
 * Common usage of this (if for some reason you want to force a `PseScript`)
 *   var loader = new PscLoader(add);
 *   loader.load("pseTest");
 *
 * The `addFn` is the add() del FlxState, passed like reference to help
 * the interpreter for adding the objects on the state
 */
class PscLoader {

    static final BASE_PATH = "data/PSeInt/";

    var interpreter:PscInterpreter;

    public function new(addFn:Dynamic -> Void) {
        interpreter = new PscInterpreter(addFn);
    }

    /**
     * @param name  Name file without extention (ej: `pseTest`).
     * @return      true if it exists and got procesed, else, false.
     */
    public function load(name:String):Bool {
        var fullPath = Paths.getPath(BASE_PATH + name + ".psc");

        if (!FileSystem.exists(fullPath)) {
            trace('File not found: $fullPath', 'PSeError');
            return false;
        }

        var raw   = File.getContent(fullPath);
        var lines = PscLexer.tokenize(raw);
        var nodes = PscParser.parse(lines);

        interpreter.run(nodes);
        return true;
    }

    /**
     * Variant of the loader, but faster and more direct, but also dangerous
     */
    public function loadString(source:String) {
        var lines = PscLexer.tokenize(source);
        var nodes = PscParser.parse(lines);
        interpreter.run(nodes);
    }
}
