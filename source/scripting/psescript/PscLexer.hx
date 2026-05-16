package scripting.psescript;

using StringTools;

/**
 *  PscLexer
 *
 *  The one who returns the psc text and tokenize it, and... thats it.
 */
class PscLexer {

    public static function tokenize(raw:String):Array<String> {
        var lines:Array<String> = [];

        var inBlockComment = false;
        var inString       = false;
        var current:Array<String> = [];

        inline function flush() {
            var s = current.join("").replace("\r", "").trim();
            if (s.length > 0) lines.push(s);
            current = [];
        }

        var i = 0;
        while (i < raw.length) {
            var ch   = raw.charAt(i);
            var next = (i < raw.length - 1) ? raw.charAt(i + 1) : "";

            // apertura / cierre de string
            if (ch == '"' && !inBlockComment) {
                inString = !inString;
                current.push(ch);
                i++;
                continue;
            }

            // dentro de un string: copiar literalmente
            if (inString) {
                current.push(ch);
                i++;
                continue;
            }

            // inicio /*
            if (!inBlockComment && ch == '/' && next == '*') {
                inBlockComment = true;
                i += 2;
                continue;
            }

            // fin */
            if (inBlockComment && ch == '*' && next == '/') {
                inBlockComment = false;
                i += 2;
                continue;
            }

            // dentro de bloque: ignorar
            if (inBlockComment) { i++; continue; }

            // comentario de línea //
            if (ch == '/' && next == '/') {
                while (i < raw.length && raw.charAt(i) != '\n') i++;
                continue;
            }

            // separador ;
            if (ch == ';') {
                flush();
                i++;
                continue;
            }

            // salto de línea
            if (ch == '\n') {
                flush();
                i++;
                continue;
            }

            // carácter normal
            current.push(ch);
            i++;
        }

        flush();
        return lines;
    }
}
