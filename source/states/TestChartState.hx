package states;

import backend.chart.PsychParser;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.UNOState;

class TestChartState extends UNOState {
    var notesText:FlxText;
    var scrollY:Float = 0;
    var totalHeight:Float = 0;

	// pito test

    // Cambia esto al nombre de tu canción
    static final SONG_NAME:String = "Premeditated";

    override public function create():Void {
        super.create();

        bgColor = FlxColor.BLACK;

        var chartData = PsychParser.parseChart(SONG_NAME, "hard");

        var output:String = "";

        if (chartData == null) {
            output = "ERROR: No se pudo parsear el chart.\nRevisa el nombre de la canción y que el archivo exista.";
        } else {
            output = 'Chart: ${chartData.songName}  |  Total notas: ${chartData.notes}\n';
            output += '─────────────────────────────────────\n';
            output += 'idx  | time (ms)   | dir | duration\n';
            output += '─────────────────────────────────────\n';

            for (i in 0...chartData.notes.length) {
                var n = chartData.notes[i];
                var dirName = switch (n.direction % 4) {
                    case 0: "LEFT ";
                    case 1: "DOWN ";
                    case 2: "UP   ";
                    case 3: "RIGHT";
                    default: "?    ";
                };
                var who = n.direction >= 4 ? "P2" : "P1";
                output += '#${StringTools.lpad(Std.string(i), " ", 4)} | '
                    + '${StringTools.lpad(Std.string(Math.round(n.time)), " ", 10)} | '
                    + '$dirName ($who) | '
                    + '${n.duration}\n';
            }
        }

        notesText = new FlxText(10, 10, FlxG.width - 20, output);
        notesText.setFormat(null, 12, FlxColor.WHITE, LEFT);
        notesText.scrollFactor.set(0, 0);
        add(notesText);

        totalHeight = notesText.height;

        // Instrucciones
        var hint = new FlxText(0, FlxG.height - 20, FlxG.width, "↑↓ o rueda del mouse para scrollear  |  ESC para salir");
        hint.setFormat(null, 10, FlxColor.GRAY, CENTER);
        hint.scrollFactor.set(0, 0);
        add(hint);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Scroll con teclado
        var scrollSpeed:Float = 300;
        if (FlxG.keys.pressed.DOWN)
            scrollY += scrollSpeed * elapsed;
        if (FlxG.keys.pressed.UP)
            scrollY -= scrollSpeed * elapsed;

        // Scroll con rueda del mouse
        scrollY -= FlxG.mouse.wheel * 40;

        // Clamp para no salir del contenido
        var maxScroll = Math.max(0, totalHeight - FlxG.height + 30);
        scrollY = Math.max(0, Math.min(scrollY, maxScroll));

        notesText.y = 10 - scrollY;

        // if (FlxG.keys.justPressed.ESCAPE)
            // FlxG.switchState(new TestChartState()); // reinicia, o cambia a tu estado principal
    }
}
