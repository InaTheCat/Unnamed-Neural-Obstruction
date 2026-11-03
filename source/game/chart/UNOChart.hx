
package game.chart;

import game.chart.PsychParser;
import haxe.Json;

#if sys
import sys.io.File;
#end

typedef UnnamedChart = {
    var song:String;
    var stage:String;
    var speed:Float;
    var bpm:Float;

    var meta:Array<Meta>;
    var strums:Array<Strums>;
}

typedef Meta = {
    var sec:Int;

    var ?lengthInSteps:Int;
    var ?sectionBeats:Int;
    var ?bpm:Float;
    var ?altAnim:Bool;
    var ?changeBPM:Bool;
    var ?mustHitSection:Bool;
}

typedef Strums = {
    var ?notes:Array<StrumNotes>;
    var ?character:String;
    var ?voice:String;
}

typedef StrumNotes = {
    var time:Float;
    var dir:Int;
    var ?len:Float;
    var ?type:String;
}

class UNOChart
{
    public static function convert(parsed:ParsedChart):String
    {
        var opponent:Array<Note> = [];
        var player:Array<Note> = [];

        var meta:Array<String> = [];

        var currentBpm:Float = parsed.bpm;
        var currentMustHit:Bool = false;

        for (i => section in parsed.sections)
        {
            if (section == null)
                continue;

            var fields:Array<String> = [];

            if (section.lengthInSteps != 16)
                fields.push('"lengthInSteps": ${section.lengthInSteps}');

            if (section.mustHitSection != currentMustHit)
            {
                currentMustHit = section.mustHitSection;
                fields.push('"mustHitSection": ${currentMustHit}');
            }

            var rawChange:Dynamic = Reflect.field(section, 'changeBPM');
            var rawBpm:Dynamic = Reflect.field(section, 'bpm');

            if (rawChange == true && rawBpm != null)
            {
                var sectionBpm:Float = Std.parseFloat(Std.string(rawBpm));

                if (!Math.isNaN(sectionBpm) && sectionBpm > 0 && sectionBpm != currentBpm)
                {
                    currentBpm = sectionBpm;

                    fields.push('"changeBPM": true');
                    fields.push('"bpm": ${num(sectionBpm)}');
                }
            }

            if (Reflect.field(section, 'altAnim') == true)
                fields.push('"altAnim": true');

            var sectionBeats:Dynamic = Reflect.field(section, 'sectionBeats');

            if (sectionBeats != null && sectionBeats != 4)
                fields.push('"sectionBeats": ${sectionBeats}');

            if (Reflect.field(section, 'gfSection') == true)
                fields.push('"gfSection": true');

            if (fields.length > 0)
            {
                fields.unshift('"sec": $i');

                meta.push('\t\t{\n${[for (f in fields) '\t\t\t$f'].join(',\n')}\n\t\t}');
            }

            var sectionNotes:Array<Dynamic> = section.sectionNotes ?? [];

            for (dt in sectionNotes)
            {
                if (dt == null || dt.length < 2)
                    continue;

                var time:Float = Std.parseFloat(Std.string(dt[0]));
                var dir:Int = Std.int(dt[1]);

                if (Math.isNaN(time))
                    continue;

                var mustHit:Bool = section.mustHitSection
                    ? dir < 4
                    : dir >= 4;

                var note:Note = {
                    time: time,
                    dir: dir,
                    len: dt.length > 2 && dt[2] != null
                        ? Std.parseFloat(Std.string(dt[2]))
                        : 0,
                    type: dt.length > 3 && dt[3] != null
                        ? Std.string(dt[3])
                        : null,
                    mustHit: mustHit
                };

                (mustHit ? player : opponent).push(note);
            }
        }

        opponent.sort((a, b) -> Reflect.compare(a.time, b.time));
        player.sort((a, b) -> Reflect.compare(a.time, b.time));

        var out:StringBuf = new StringBuf();

        out.add('{\n');
        out.add('\t"song": ${Json.stringify(parsed.song)},\n');
        out.add('\t"stage": ${Json.stringify(parsed.stage)},\n');
        out.add('\t"speed": ${num(parsed.speed)},\n');
        out.add('\t"bpm": ${num(parsed.bpm)},\n');

        out.add('\t"meta": [\n');
        out.add(meta.join(',\n'));
        out.add('\n\t],\n');

        out.add('\t"strums": [\n');

        var strums:Array<String> = [];

        if (opponent.length > 0)
            strums.push(strumBlock(opponent, parsed.player1));

        if (player.length > 0)
            strums.push(strumBlock(player, parsed.player2));

        out.add([for (strum in strums)'\t\t${strum}'].join(',\n'));

        out.add('\n\t]\n');
        out.add('}');

        return out.toString();
    }

    public static function convertFile(tar:Array<String>, end:Array<String>):Void
    {
        #if sys
        var songName:String = tar[0];
        var diff:String = tar[1] ?? 'hard';

        var raw:Dynamic = Json.parse(Paths.getContent('songs/$songName/chart/$diff.json'));

        if (raw.song == null)
        {
            Logs.send('invalid chart: missing song data', Error);
            return;
        }

        var parsed:ParsedChart = PsychParser.parse(songName, diff);

        var json:String = convert(parsed);

        var tSong:String = end[0];
        var tDiff:String = end[1] ?? 'normal';

        File.saveContent('assets/songs/$tSong/chart/$tDiff.json', json);

        Logs.internal('chart saved at "songs/$tSong/chart/$tDiff.json"');
        #else
        Logs.send('couldnt save the chart cuz u aint on a Sys target', Error);
        #end
    }

    static function strumBlock(notes:Array<Note>, character:String):String
    {
        var b:StringBuf = new StringBuf();

        b.add('{\n');
        b.add('\t\t\t"notes": [\n');

        b.add([
            for (n in notes)
                '\t\t\t\t${noteLine(n)}'
        ].join(',\n'));

        b.add('\n\t\t\t],\n');
        b.add('\t\t\t"character": ${Json.stringify(character)},\n');
        b.add('\t\t\t"voice": ""\n');
        b.add('\t\t}');

        return b.toString();
    }

    static function noteLine(n:Note):String
    {
        var hasType:Bool = n.type != null && n.type != '';
        var len:Float = n.len ?? 0;

        var parts:Array<String> = [
            num(n.time),
            Std.string(n.dir % 4)
        ];

        if (len > 0 || hasType)
            parts.push(num(len));

        if (hasType)
            parts.push(Json.stringify(n.type));

        return '[${parts.join(', ')}]';
    }

    static inline function num(f:Float):String
        return Std.string(Math.round(f * 1000) / 1000);

    public static function toTypedef(name:String, diff:String):UnnamedChart {
        var chart:Dynamic = Json.parse(convert(PsychParser.parse(name, diff)));

        var strums:Array<Strums> = [];
        var meta:Array<Meta> = [];

        if (chart.meta != null && chart.meta.length != 0){
            for (i in 0...chart.meta.length){
                var sec:Null<Int> = chart.meta[i].sec;
                var lengthInSteps:Int = chart.meta[i].lengthInSteps ?? null;
                var sectionBeats:Int = chart.meta[i].sectionBeats ?? null;
                var bpm:Float = chart.meta[i].bpm ?? null;
                var altAnim:Bool = chart.meta[i].altAnim ?? null;
                var changeBPM:Bool = chart.meta[i].changeBPM ?? null;
                var mustHitSection:Bool = chart.meta[i].mustHitSection ?? null;

                if (sec != null)
                    meta.push({
                        sec: sec, lengthInSteps: lengthInSteps, sectionBeats: sectionBeats, bpm: bpm, altAnim: altAnim, changeBPM: changeBPM, mustHitSection: mustHitSection
                    });
            }
        }

        if (chart.strums != null){
            for (group in cast(chart.strums, Array<Dynamic>)){
                if (group == null)
                    continue;

                var notes:Array<StrumNotes> = [];
                var sourceNotes:Array<Dynamic> = group.notes ?? [];

                for (sourceNote in sourceNotes){
                    if (sourceNote == null)
                        continue;

                    var time:Float;
                    var dir:Int;
                    var len:Float = 0;
                    var type:String = '';

                    if (Std.isOfType(sourceNote, Array)){
                        var values:Array<Dynamic> = cast sourceNote;

                        if (values.length < 2)
                            continue;

                        time = Std.parseFloat(Std.string(values[0]));
                        dir = Std.int(values[1]);
                        if (values.length > 2 && values[2] != null)
                            len = Std.parseFloat(Std.string(values[2]));
                        if (values.length > 3 && values[3] != null)
                            type = Std.string(values[3]);
                    } else {
                        time = sourceNote.time;
                        dir = sourceNote.dir;
                        len = sourceNote.len ?? 0;
                        type = sourceNote.type ?? '';
                    }

                    if (Math.isNaN(time))
                        continue;

                    notes.push({time: time, dir: dir, len: len, type: type});
                }

                strums.push({
                    notes: notes,
                    character: group.character,
                    voice: group.voice
                });
            }
        }

        var song:String = Paths.exists('songs/${chart.song}/song/Inst.ogg') ? chart.song : name;

        return {
            song: song,
            stage: chart.stage,
            speed: chart.speed,
            bpm: chart.bpm,
            meta: meta,
            strums: strums
        }
     }
}
