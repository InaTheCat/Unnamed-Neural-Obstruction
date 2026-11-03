package game.managers.music;

import flixel.sound.FlxSound;

class VoicesPack {
    public var vocals:Array<FlxSound>;

    public function new()
        vocals = [];

    public function save(voice:FlxSound) vocals.push(voice);

    public function play() {
        if (vocals.length == 0)
            return;

        for (e in vocals)
            e.play();
    }

    public function destroy() {
        if (vocals.length == 0)
            return;

        for (e in vocals)
            e.stop();

        vocals = null;
    }

    public function update(music:FlxSound) {
        if (vocals.length == 0 || FlxG.sound?.music == null)
            return;

        for (e in vocals)
            if (Math.abs(e.time - music.time) > 20)
                e.time = FlxG.sound.music.time;
    }
}