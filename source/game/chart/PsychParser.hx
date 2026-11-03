package game.chart;

typedef ParsedChart = {
    var notes:Array<Note>;
    var sections:Array<ChartNotes>;
    var bpm:Float;
    var speed:Float;
    var song:String;

    var ?player1:String;
    var ?player2:String;
    var ?stage:String;
}

typedef Chart = {
    var song:SongField;
}

typedef SongField = {
    var notes:Array<ChartNotes>;
    var speed:Float;

    var ?player1:String;
    var ?player2:String;
    var ?stage:String;

    var song:String;
    var bpm:Float;
}

typedef ChartNotes = {
    var lengthInSteps:Int;
    var mustHitSection:Bool;
    var sectionNotes:Array<Dynamic>;

    var ?bpm:Float;
    var ?changeBPM:Bool;
    var ?altAnim:Bool;
    var ?sectionBeats:Float;
    var ?gfSection:Bool;
}

typedef Note = {
    var time:Float;
    var dir:Int;
    var ?len:Float;
    var ?type:String;
    var mustHit:Bool;
}

/**
 * also works with legacy charts btw heh
**/
class PsychParser {
    public static function parse(songName:String, diff:String = 'hard'):ParsedChart {
        var chart:Chart = CoolUtil.parseJson('songs/$songName/chart/$diff');

        var notes:Array<Note> = [];
        var sections:Array<ChartNotes> = [];

        if (chart == null || chart.song == null)
            return {notes: notes, sections: sections, bpm: 100, speed: 1, player1: 'dad', player2: 'bf', stage: 'stage', song: 'test'}

        var data:SongField = chart.song;

        if (data.notes != null && data.notes.length > 0){
            sections = data.notes;

            for (section in sections){
                if (section == null || section.sectionNotes == null)
                    continue;

                var mustHitSection:Bool = section.mustHitSection;

                var sectionNotes:Array<Dynamic> = section.sectionNotes;

                for (dt in sectionNotes){
                    var dir:Int = dt[1];
                    var noteMustHit:Bool;

					if (mustHitSection)
						noteMustHit = dir < 4;
					else
						noteMustHit = dir >= 4;

                    notes.push({
                        time: dt[0],
                        dir: dir,
                        len: dt[2] ?? 0,
                        type: dt[3] ?? null,
                        mustHit: noteMustHit
                    });
                }
            }
        }

        notes.sort((a, b) -> Reflect.compare(a.time, b.time));

        return {
            notes: notes,
            sections: sections,
            bpm: data.bpm ?? 100,
            speed: data.speed ?? 100,

            song: data.song ?? 'test',
            player1: data.player1 ?? 'dad',
            player2: data.player2 ?? 'bf',
            stage: data.stage ?? 'stage'
        };
    }
}