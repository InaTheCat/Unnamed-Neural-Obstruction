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

			// Start and end of String
            if (ch == '"' && !inBlockComment) {
                inString = !inString;
                current.push(ch);
                i++;
                continue;
            }

			// if in string, we copy it, like, fr
            if (inString) {
                current.push(ch);
                i++;
                continue;
            }

			// Start of Block comment /*
            if (!inBlockComment && ch == '/' && next == '*') {
                inBlockComment = true;
                i += 2;
                continue;
            }

			// End of Block comment */
            if (inBlockComment && ch == '*' && next == '/') {
                inBlockComment = false;
                i += 2;
                continue;
            }

			// We aint reading ts gng
            if (inBlockComment) { i++; continue; }

			// Single line comment //
            if (ch == '/' && next == '/') {
                while (i < raw.length && raw.charAt(i) != '\n') i++;
                continue;
            }

			// Ion even remember if PSeInt has ';', but we do
            if (ch == ';') {
                flush();
                i++;
                continue;
            }

			// Line jump
            if (ch == '\n') {
                flush();
                i++;
                continue;
            }

			// Common char
            current.push(ch);
            i++;
        }

        flush();
        return lines;
    }
}
