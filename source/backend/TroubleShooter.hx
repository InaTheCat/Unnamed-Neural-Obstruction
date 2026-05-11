package backend;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class TroubleShooter extends FlxBasic {
    public static var instance:TroubleShooter;

    // El grupo ya no necesita ser estático público si solo se dibuja desde aquí
    public var troubleShooter:FlxTypedSpriteGroup<Dynamic>;
    public var troubleText:FlxText;
    public var troubleBg:FlxSprite;
    private var hideTimer:FlxTimer = null;

    public var typeColors:Map<String, Int> = [
        'Info' => 0x0000FF,
        'Warning' => 0xFFFF00,
        'Error' => 0xFF0000,
        'None' => 0xFFFFFFFF
    ];

    public function new() {
        super();
        instance = this;

        troubleShooter = new FlxTypedSpriteGroup<Dynamic>();
        troubleShooter.scrollFactor.set();
        troubleShooter.alpha = 0;

        // 1. Crear bg y texto con posiciones RELATIVAS al grupo (0,0 base)
        troubleBg = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
        troubleBg.alpha = 0.75;

        troubleText = new FlxText(20, 10, 0, 'Initial Message', 16);
        troubleText.setFormat(null, 16, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);

        // 2. AGREGAR al grupo — este era el bug principal
        troubleShooter.add(troubleBg);
        troubleShooter.add(troubleText);

        // 3. Posición inicial fuera de pantalla (izquierda, abajo)
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        troubleShooter.update(elapsed);
    }

    override public function draw():Void {
        // Solo dibujamos el grupo; él se encarga de sus hijos
        troubleShooter.draw();
    }

    public function send(message:String, ?shootType:String = 'Info', ?displayTime:Float = 2):Void {
        FlxTween.cancelTweensOf(troubleShooter);
        if (hideTimer != null) hideTimer.cancel();

        displayTime ?? 2;
        shootType ?? 'Info';

        troubleShooter.alpha = 0;
        troubleShooter.setPosition(-troubleShooter.width, FlxG.height - troubleBg.height);

        troubleText.text = message + (shootType != 'None' ? '\n\n[$shootType]' : '');

        troubleText.color = typeColors.exists(shootType) ? typeColors[shootType] : 0xFFFFFFFF;

        // Update shoot troubleBg
        troubleBg.makeGraphic(Std.int(troubleText.textField.textWidth + 40), Std.int(troubleText.textField.textHeight + 40), 0xFFFFFFFF);

        troubleText.y = FlxG.height - troubleBg.height;

        troubleBg.setPosition(troubleText.x - 20, troubleText.y - 20);
        troubleBg.updateHitbox();

        // Notification appears
        FlxTween.tween(troubleShooter, {x: -10, alpha: 0.6}, 0.5, {ease: FlxEase.quadOut, onComplete: function(_) {
            hideTimer = new FlxTimer().start(displayTime, function(_) {
                hide();
            });
        }});
    }

    private function hide():Void {
        FlxTween.cancelTweensOf(troubleShooter);
        FlxTween.tween(troubleShooter, {x: -troubleBg.width, alpha: 0}, 0.7, {
            ease: FlxEase.quadIn,
            onComplete: (_) -> {
                troubleShooter.alpha = 0;
            }
        });
    }
}

/*
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

private class TSEntry {
    public var group:FlxTypedSpriteGroup<Dynamic>;
    public var bg:FlxSprite;
    public var text:FlxText;
    public var timer:FlxTimer;
    public var entryHeight:Float = 0; // altura fija, no depende del tween

    public function new() {}
}

class TroubleShooter extends FlxBasic {
    public static var instance:TroubleShooter;

    static final MAX_ENTRIES:Int    = 10;
    static final ENTRY_GAP:Float    = 8;
    static final SLIDE_IN:Float     = 0.4;
    static final SLIDE_OUT:Float    = 0.5;
    static final REPOSITION:Float   = 0.3;
    static final BOTTOM_MARGIN:Float = 12;

    private var _entries:Array<TSEntry> = [];

    public var typeColors:Map<String, Int> = [
        'Info'    => 0xFF0000FF,
        'Warning' => 0xFFFFFF00,
        'Error'   => 0xFFFF0000
    ];

    public function new() {
        super();
        instance = this;
    }

    override public function draw():Void {
        for (e in _entries) e.group.draw();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        for (e in _entries) e.group.update(elapsed);
    }

    public function send(message:String, ?shootType:String = 'Info', ?displayTime:Float = 2.5):Void {
        if (_entries.length >= MAX_ENTRIES)
            _removeEntry(_entries[_entries.length - 1]);

        var entry = _buildEntry(message, shootType);
        _entries.unshift(entry);

        _repositionAll(entry);

        entry.timer = new FlxTimer().start(displayTime, function(_) {
            _removeEntry(entry);
        });
    }

    private function _buildEntry(message:String, shootType:String):TSEntry {
        var e = new TSEntry();

        e.group = new FlxTypedSpriteGroup<Dynamic>();
        e.group.scrollFactor.set();
        e.group.alpha = 0;

        e.bg = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
        e.bg.alpha = 0.6;
        e.group.add(e.bg);

        e.text = new FlxText(16, 0, 0, message, 15);
        e.text.setFormat(null, 15, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        e.text.color = typeColors.exists(shootType) ? typeColors[shootType] : 0xFFFFFFFF;
        e.group.add(e.text);

        var tw = Std.int(e.text.textField.textWidth + 32);
        var th = Std.int(e.text.textField.textHeight + 24);
        e.bg.makeGraphic(tw, th, 0xFF000000);
        e.bg.updateHitbox();
        e.text.y = (th - e.text.textField.textHeight) * 0.5;

        // guardamos la altura real una sola vez aquí, ya no la recalculamos
        e.entryHeight = th;

        e.group.x = -tw - 10;
        e.group.alpha = 0;

        return e;
    }

    // Calcula el Y destino de cada entrada usando entryHeight, no el estado del tween
    private function _targetY(index:Int):Float {
        var y = FlxG.height - BOTTOM_MARGIN;
        for (i in 0...index + 1)
            y -= _entries[i].entryHeight + (i < index ? ENTRY_GAP : 0);
        return y;
    }

    private function _repositionAll(newEntry:TSEntry):Void {
        for (i in 0..._entries.length) {
            var e = _entries[i];
            var destY = _targetY(i);

            FlxTween.cancelTweensOf(e.group);

            if (e == newEntry) {
                e.group.y = destY + 16;
                FlxTween.tween(e.group, {x: -8, y: destY, alpha: 0.9}, SLIDE_IN, {
                    ease: FlxEase.quadOut
                });
            } else {
                FlxTween.tween(e.group, {y: destY}, REPOSITION, {
                    ease: FlxEase.quadOut
                });
            }
        }
    }

    private function _removeEntry(entry:TSEntry):Void {
        var idx = _entries.indexOf(entry);
        if (idx == -1) return;

        _entries.splice(idx, 1);

        if (entry.timer != null) {
            entry.timer.cancel();
            entry.timer = null;
        }

        FlxTween.cancelTweensOf(entry.group);
        FlxTween.tween(entry.group, {x: -entry.bg.width - 10, alpha: 0}, SLIDE_OUT, {
            ease: FlxEase.quadIn,
            onComplete: function(_) { entry.group.destroy(); }
        });

        // reposicionar los que quedan, sin newEntry
        _repositionAll(null);
    }

    override public function destroy():Void {
        for (e in _entries) {
            if (e.timer != null) e.timer.cancel();
            e.group.destroy();
        }
        _entries = [];
        super.destroy();
    }
}
*/