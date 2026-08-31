package states.editors.charter;

import backend.chart.NewTestChartparser;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import states.editors.charter.Note;
import states.editors.charter.Strum;
import states.editors.charter.Sustain;

class Charter extends FlxState {
    static var songName:String = 'Ectospasm';
    static var voicesName:Array<String> = ['Voices'];

    final gridSize:Float = 110;

    private var songEnd:Float = 0;

    private var notesSetted:Bool = false;

    var editorStats:FlxText;

    var strums:FlxSpriteGroup;
    var player:FlxSpriteGroup;
    var opponent:FlxSpriteGroup;

    var guiders:FlxSpriteGroup;
    var strumLines:FlxSpriteGroup;

    var grid1:FlxBackdrop;
    var grid2:FlxBackdrop;

    var sectionSep1:FlxBackdrop;
    var sectionSep2:FlxBackdrop;

    var noteLine1:FlxSprite;
    var noteLine2:FlxSprite;
    var strum1:Strum;
    var strum2:Strum;

    var chart:Null<ParsedChart>;

    var bg:FlxBackdrop;

    public var charterCam:FlxCamera = new FlxCamera();
	public var overlay:FlxCamera = new TroubleShooter();

    public var inst:FlxSound;
    public var voices:Array<FlxSound>;

    var playingSong:Bool = false;

	override public function create():Void
	{
        super.create();

		FlxG.cameras.add(charterCam);
        charterCam.zoom = 0.8;

		FlxG.cameras.add(overlay, false);

        add(bg = new FlxBackdrop(Paths.image('editors/charter/bg')));
        bg.scrollFactor.set(0.25, 0.25);
		bg.antialiasing = Options.antialiasing ?? true;

        add(strums = new FlxSpriteGroup());

        strums.add(grid1 = new FlxBackdrop(Paths.image('editors/charter/grid'), Y));
        strums.add(grid2 = new FlxBackdrop(Paths.image('editors/charter/grid'), Y));
        grid2.x = 500;

        strums.add(sectionSep1 = new FlxBackdrop(null, Y, 0, 1750));
        sectionSep1.makeGraphic(435, 10, 0xFFFFFFFF);

        strums.add(sectionSep2 = new FlxBackdrop(null, Y, 0, 1750));
        sectionSep2.makeGraphic(435, 10, 0xFFFFFFFF);
        sectionSep2.x = 500;

        strums.add(player = new FlxSpriteGroup());
        strums.add(opponent = new FlxSpriteGroup());

        strums.add(guiders = new FlxSpriteGroup());
        guiders.add(strumLines = new FlxSpriteGroup());

        strumLines.add(strum1 = new Strum(0, 0, 0.7));
        strumLines.add(strum2 = new Strum(500, 0, 0.7));

        guiders.add(noteLine1 = new FlxSprite().makeGraphic(435, 10, 0xFFFFFFFF));
        guiders.add(noteLine2 = new FlxSprite(500).makeGraphic(435, 10, 0xFFFFFFFF));

        chart = NewTestChartparser.parseChart('$songName', 'hard');

        Conductor.reset();
        Conductor.mapSong(chart.bpm, chart.speed);

        FlxG.sound.playMusic(Paths.songInst('$songName'), 1, true);
        songEnd = FlxG.sound?.music?.length;
        FlxG.sound?.music?.pause();

        voices = [];

        for (e in voicesName){
            if (voicesName.length == 0) return;

            var voice:FlxSound = FlxG.sound.load(Paths.songVoices('$songName', e.toLowerCase() == 'voices' ? '' : e, false), 0.7, true, null, true, false);
            voice.play();
            voice.pause();
            voices.push(voice);
        }

		add(editorStats = new FlxText(0, 50, 0, 'Time: 0\nStep: 0\nBeat: 0\nSection: 0', 32).setFormat(null, 32, 0xFFFFFFFF, 'left', OUTLINE, 0xFF000000));
		editorStats.camera = overlay;

        initNotes();
    }

    private function initNotes() {
        if (chart == null || chart.notes == null){
            var thing:String = 'dunno';

            if (chart == null) thing = 'chart';
            else if (chart.notes == null) thing = 'notes field';
            else thing = 'everything';
            
			Logs.send('$thing is null. Returning...', {type: Error});

            return;
        }

        if (notesSetted){
			Logs.send('Notes already initialized', {type: Info});
            return;
        }

        for (i => nts in chart.notes){
            var note:Note = new Note(nts.dir * 109, (nts.time / Conductor.stepCrochet) * gridSize, nts.dir, nts.sustain > 0, nts.sustain, nts.mustHit);

			// Logs.send('Note $i created with [Dir: ${note.dir}, hasSustain: ${note.hasSustain}, isPlayer: ${note.isPlayer}]', {type: SourceInfo, showShooter: false});

            if (note.isPlayer)
                player.add(note);
            else
                opponent.add(note);

            if (note.hasSustain){
                var sustain:Sustain = new Sustain(note.x + (note.frameWidth / 2) - 32, note.y + (note.frameHeight / 2), note.sustainLength, note.dir);

				// Logs.send('Note $i, ${note.isPlayer ? 'player' : 'opponent'} side had sustain and created with [Dir: ${note.dir}, size: ${note.sustainLength}]', {type: SourceInfo, showShooter: false});

                if (note.isPlayer)
                    player.add(sustain);
                else
                    opponent.add(sustain);
            }
        }

        strums.screenCenter(X);

        notesSetted = true;
    }

    /**
     * mmmmm pan, q riko el pan ouyea
    **/
    var chartPan:Float = 0;

    var chartScrollOffset:Float = 0;
    var chartScroll:Float = 0;
    var chartZoom:Float = 0.8;

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

        Conductor.update(charterCam.scroll.y);

        if (FlxG.keys.justPressed.SPACE){
            playingSong = !playingSong;

            songStatus(playingSong);
        }

        if (playingSong) {
            if (FlxG.mouse.wheel != 0 && !FlxG.keys.anyPressed([SHIFT, CONTROL]) || FlxG.keys.anyJustPressed([A, D])){
                playingSong = false;
            
                songStatus(false);
            }

            chartScroll = FlxG.sound?.music?.time;

            if (voicesName.length != 0) {
                for (e in voices){
                    var diff:Float = Math.abs(e.time - FlxG.sound?.music?.time);

                    if (diff > 20)
                        e.time = FlxG.sound?.music?.time;
                }
            }
        }

        if (FlxG.mouse.wheel != 0)
            if (FlxG.keys.pressed.CONTROL)
                if (FlxG.keys.pressed.ALT)
                    chartScrollOffset -= FlxG.mouse.wheel * 24;
                else
                    chartZoom += FlxG.mouse.wheel > 0 ? 0.05 : -0.05;
            else if (FlxG.keys.pressed.SHIFT)
                chartPan += FlxG.mouse.wheel * 12;
            else
                chartScroll -= FlxG.mouse.wheel * 32;

        if (FlxG.keys.justPressed.A)
            chartScroll -= 32;
        if (FlxG.keys.justPressed.D)
            chartScroll += 32;

        chartZoom = FlxMath.bound(chartZoom, 0.25, 2);
        charterCam.zoom = CoolUtil.lerp(charterCam.zoom, chartZoom, 0.15);

        chartPan = FlxMath.bound(chartPan, -200, 200);
        charterCam.scroll.x = CoolUtil.lerp(charterCam.scroll.x, chartPan, 0.15);

        chartScroll = FlxMath.bound(chartScroll, 0, FlxG.sound?.music?.length);

        chartScrollOffset = FlxMath.bound(chartScrollOffset, -200, 200);

        var currentMs:Float = playingSong ? Conductor.songPosition : chartScroll;
        var scrollPos:Float = (currentMs / Conductor.stepCrochet) * gridSize;

        if (playingSong) {
            charterCam.scroll.y = scrollPos + chartScrollOffset;
            guiders.y = charterCam.scroll.y - chartScrollOffset;
        } else {
            charterCam.scroll.y = CoolUtil.lerp(charterCam.scroll.y, scrollPos + chartScrollOffset, 0.25);
            guiders.y = CoolUtil.lerp(guiders.y, charterCam.scroll.y - chartScrollOffset, 0.1);
        }

        editorStats.text = 'Scroll: ${FlxMath.roundDecimal(charterCam.scroll.y, 3) ?? 0}\nTime: ${FlxG.sound?.music?.time}\nStep: ${Conductor.curStep ?? 0}\nBeat: ${Conductor.curBeat ?? 0}\nSection: ${Conductor.curSection ?? 0}';

        final renderMargin:Float = 1250;

        var cameraTop:Float = charterCam.scroll.y - renderMargin;
        var cameraBottom:Float = charterCam.scroll.y + renderMargin + 200;

        for (notes in [player, opponent]){
            for (note in notes.members){
                if (note == null) continue;
            
                var visibleNow:Bool = note.y + note.height >= cameraTop && note.y <= cameraBottom;
            
                note.visible = visibleNow;
                note.active = visibleNow;
            }
        }
    }

    public function songStatus(playing:Bool) {
        playingSong = playing;

        if (FlxG.sound?.music != null)
            FlxG.sound.music.time = chartScroll;

        if (playing){
            FlxG.sound?.music?.resume();

            if (voicesName.length != 0)
                for (e in voices)
                    e.play();
        } else {
            FlxG.sound?.music?.pause();
        
            if (voicesName.length != 0)
                for (e in voices)
                    e.pause();
        }    
    }
}