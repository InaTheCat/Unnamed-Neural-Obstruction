package scripting.psescript;

using StringTools;

/**
 * PscParser
 * Recibe líneas limpias (del PscLexer) y las convierte en PscNode.
 *
 * Gramática soportada (híbrido PSeInt / HScript):
 *
 *   Declarations:
 *     definir  <name> como <Type>
 *     Definir  <name> como <Type>
 *     define   <name> como <Type>
 *     var      <name> como <Type>
 *
 *   Asignación de propiedad con punto:
 *     <var>.sprite  = "ruta"
 *     <var>.<prop>  = <valor>
 *
 *   Llamadas a método con punto:
 *     <var>.pos(x, y)
 *     <var>.scale(x, y)
 *     <var>.alpha(v)
 *     <var>.visible(true|false)
 *
 *   Funciones del scope:
 *     add(<var>)
 */
class PscParser {

    // Palabras clave que inician una declaración de variable
    static final DECL_KEYWORDS = ["definir", "Definir", "define", "var"];

    public static function parse(lines:Array<String>):Array<PscNode> {
        var nodes:Array<PscNode> = [];
        for (line in lines) {
            nodes.push(parseLine(line));
        }
        return nodes;
    }

    // ── parser de una línea ──────────────────────────────────────────────────

    static function parseLine(line:String):PscNode {

        // ── declaración de variable ──────────────────────────────────────────
        for (kw in DECL_KEYWORDS) {
            if (line.startsWith(kw + " ") || line == kw) {
                return parseDeclaration(line);
            }
        }

        // ── add(<var>) ───────────────────────────────────────────────────────
        if (line.startsWith("add(") && line.endsWith(")")) {
            var varName = line.substring(4, line.length - 1).trim();
            return AddToScene(varName);
        }

        // ── sentencias con punto  <var>.<algo> ──────────────────────────────
        var dotIdx = line.indexOf(".");
        if (dotIdx > 0) {
            return parseDotStatement(line, dotIdx);
        }

        return Unknown(line);
    }

    // ── declaración  definir X como Tipo ────────────────────────────────────

    static function parseDeclaration(line:String):PscNode {
        // normalizar a minúsculas solo la keyword, dejar el resto igual
        var parts = ~/\s+/.split(line.trim());
        // partes esperadas: ["definir", "nombre", "como", "Tipo"]
        if (parts.length >= 4 && parts[2].toLowerCase() == "como") {
            return DeclareVar(parts[1], parts[3]);
        }
        // forma corta  var nombre Tipo
        if (parts.length >= 3) {
            return DeclareVar(parts[1], parts[2]);
        }
        return Unknown(line);
    }

    // ── sentencia con punto ──────────────────────────────────────────────────

    static function parseDotStatement(line:String, dotIdx:Int):PscNode {
        var varName = line.substring(0, dotIdx).trim();
        var rest    = line.substring(dotIdx + 1).trim(); // todo después del primer punto

        // asignación  <var>.<prop> = <valor>
        if (rest.contains("=")) {
            return parseAssignment(varName, rest);
        }

        // llamada  <var>.<method>(args)
        var parenOpen = rest.indexOf("(");
        if (parenOpen > 0 && rest.endsWith(")")) {
            var method = rest.substring(0, parenOpen).trim();
            var argsRaw = rest.substring(parenOpen + 1, rest.length - 1).trim();
            return parseMethodCall(varName, method, argsRaw);
        }

        return Unknown(line);
    }

    // ── asignación de propiedad ──────────────────────────────────────────────

    static function parseAssignment(varName:String, rest:String):PscNode {
        var eqIdx   = rest.indexOf("=");
        var prop    = rest.substring(0, eqIdx).trim();
        var rawVal  = rest.substring(eqIdx + 1).trim().replace('"', "");

        switch (prop.toLowerCase()) {
            case "sprite":
                return SetSprite(varName, rawVal);
            default:
                return SetProperty(varName, prop, rawVal);
        }
    }

    // ── llamada a método ─────────────────────────────────────────────────────

    static function parseMethodCall(varName:String, method:String, argsRaw:String):PscNode {
        switch (method.toLowerCase()) {
            case "pos":
                var coords = splitArgs(argsRaw);
                if (coords.length >= 2) {
                    return SetPos(varName,
                        Std.parseFloat(coords[0]),
                        Std.parseFloat(coords[1]));
                }

            case "scale":
                var coords = splitArgs(argsRaw);
                if (coords.length >= 2) {
                    return SetScale(varName,
                        Std.parseFloat(coords[0]),
                        Std.parseFloat(coords[1]));
                }

            case "alpha":
                var args = splitArgs(argsRaw);
                if (args.length >= 1) {
                    return SetAlpha(varName, Std.parseFloat(args[0]));
                }

            case "visible":
                var val = argsRaw.trim().toLowerCase();
                return SetVisible(varName, val == "true" || val == "1");
        }

        // método no reconocido → lo guardamos igual como SetProperty
        // para que el intérprete pueda hacer fallback
        return SetProperty(varName, method + "(" + argsRaw + ")", "");
    }

    // ── Utilities ───────────────────────────────────────────────────────────

    /** Divide los argumentos de una llamada por comas, respetando strings. */
    static function splitArgs(raw:String):Array<String> {
        var result:Array<String> = [];
        var current = "";
        var inStr   = false;

        for (i in 0...raw.length) {
            var ch = raw.charAt(i);
            if (ch == '"') { inStr = !inStr; current += ch; continue; }
            if (!inStr && ch == ',') {
                result.push(current.trim());
                current = "";
            } else {
                current += ch;
            }
        }
        if (current.trim().length > 0) result.push(current.trim());
        return result;
    }
}
