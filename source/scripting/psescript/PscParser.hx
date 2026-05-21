package scripting.psescript;

using StringTools;

/**
 * PscParser
 * Recibes clean lines from `PscLexer` and converts it into `PscNode`
 *
 * Supported Gram:
 *
 *   Declarations:
 *     definir  <name> como <Type> = value;
 *     Definir  <name> como <Type> = value;
 *     define   <name> como <Type> = value;
 *     var      <name> como <Type> = value;
 *
 *     `como` can be writted as... `as`:
 *     
 *     definir <name> as <Type> = value;
 *     Definir <name> as <Type> = value;
 *     define  <name> as <Type> = value;
 *     var     <name> as <Type> = value;
 *
 *     or you can just put nothing, it'll behaves as a Dynamic with this:
 *
 *     definir <name> = value;
 *     Definir <name> = value;
 *     define  <name> = value;
 *     var     <name> = value;
 *
 *     like any other languages (like as hx or Lua), doing `= value;` is optional, u can do it later if you want to
 *
 *   Like as hx and many other big thangs, u can set properties and more with points:
 *     <var>.sprite  = 'ruta' `This method will be rewritted`
 *     <var>.<prop>  = <value> 
 *
 *     <var>.pos(x, y)
 *     <var>.scale(x, y)
 *     <var>.alpha(v)
 *     <var>.visible(true|false)
 *
 *   And also... right, adding:
 *     add(<var>)
 */
class PscParser {

    // Types of defining/making a var
    static final DECL_KEYWORDS = ['definir', 'Definir', 'define', 'var'];

    public static function parse(lines:Array<String>):Array<PscNode> {
        var nodes:Array<PscNode> = [];
        for (line in lines) {
            nodes.push(parseLine(line));
        }
        return nodes;
    }

    static function parseLine(line:String):PscNode {

        // ── Var declaration ──────────────────────────────────────────
        for (kw in DECL_KEYWORDS) {
            if (line.startsWith(kw + ' ') || line == kw) {
                return parseDeclaration(line);
            }
        }

        // ── add(<var>) ───────────────────────────────────────────────────────
        if (line.startsWith('add(') && line.endsWith(')')) {
            var varName = line.substring(4, line.length - 1).trim();
            return AddToScene(varName);
        }

        // ── Sentences with point (<var>.<prop> = <value>) ──────────────────────────────
        var dotIdx = line.indexOf('.');
        if (dotIdx > 0) {
            return parseDotStatement(line, dotIdx);
        }

        return Unknown(line);
    }

    // ── Declaration ────────────────────────────────────

    static function parseDeclaration(line:String):PscNode {
        // me when i normalize:
        var parts = ~/\s+/.split(line.trim());

        if (parts.length >= 4 && (parts[2].toLowerCase() == 'como' || parts[2].toLowerCase() == 'as')) {
            return DeclareVar(parts[1], parts[3]);
        }

        // Shorter type of declaration
        if (parts.length >= 3) {
            return DeclareVar(parts[1], parts[2]);
        }

        /**
            `ADD THE FUCKING DYNAMIC TYPE MAN`

            Definir|definir|define|var <Name>;
        **/

        return Unknown(line);
    }

    // ── Statement with a fucking point gng ──────────────────────────────────────────────────

    static function parseDotStatement(line:String, dotIdx:Int):PscNode {
        var varName = line.substring(0, dotIdx).trim();
        var rest = line.substring(dotIdx + 1).trim();

        // <var>.<prop> = <value>
        if (rest.contains('=')) {
            return parseAssignment(varName, rest);
        }

        // <var>.<method>(args)
        var parenOpen = rest.indexOf('(');
        if (parenOpen > 0 && rest.endsWith(')')) {
            var method = rest.substring(0, parenOpen).trim();
            var argsRaw = rest.substring(parenOpen + 1, rest.length - 1).trim();
            return parseMethodCall(varName, method, argsRaw);
        }

        return Unknown(line);
    }

    // ── Property asign ──────────────────────────────────────────────

    static function parseAssignment(varName:String, rest:String):PscNode {
        var eqIdx   = rest.indexOf('=');
        var prop    = rest.substring(0, eqIdx).trim();
        var rawVal  = rest.substring(eqIdx + 1).trim().replace('"', '');

        switch (prop.toLowerCase()) {
            case 'sprite':
                return SetSprite(varName, rawVal);
            default:
                return SetProperty(varName, prop, rawVal);
        }
    }

    // ── Method call ─────────────────────────────────────────────────────

    static function parseMethodCall(varName:String, method:String, argsRaw:String):PscNode {
        switch (method.toLowerCase()) {
            case 'pos':
                var coords = splitArgs(argsRaw);
                if (coords.length >= 2) {
                    return SetPos(varName,
                        Std.parseFloat(coords[0]),
                        Std.parseFloat(coords[1]));
                }

            case 'scale':
                var coords = splitArgs(argsRaw);
                if (coords.length >= 2) {
                    return SetScale(varName,
                        Std.parseFloat(coords[0]),
                        Std.parseFloat(coords[1]));
                }

            case 'alpha':
                var args = splitArgs(argsRaw);
                if (args.length >= 1) {
                    return SetAlpha(varName, Std.parseFloat(args[0]));
                }

            case 'visible':
                var val = argsRaw.trim().toLowerCase();
                return SetVisible(varName, val == 'true' || val == '1');
        }

        // If the method wasnt recognized, it'll be saved as SetProperty for Fallback
        return SetProperty(varName, method + '(' + argsRaw + ')', '');
    }

    // ── Utilities ───────────────────────────────────────────────────────────

    // we diving, kids, we getting strings, calls and shii with commas
    static function splitArgs(raw:String):Array<String> {
        var result:Array<String> = [];
        var current = '';
        var inStr   = false;

        for (i in 0...raw.length) {
            var ch = raw.charAt(i);
            if (ch == '"') { inStr = !inStr; current += ch; continue; }
            if (!inStr && ch == ',') {
                result.push(current.trim());
                current = '';
            } else {
                current += ch;
            }
        }
        if (current.trim().length > 0) result.push(current.trim());
        return result;
    }
}
