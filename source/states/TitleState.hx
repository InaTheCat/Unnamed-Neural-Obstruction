package states;

import flixel.group.FlxSpriteGroup;
import game.Alphabet;
import game.objects.UNOSprite;
import openfl.Assets;

using StringTools;

class TitleState extends UNOState {
	// ik its really NOT useful or really stupid to do ts but, it works like this
	public var madafakingCam:FlxCamera = new FlxCamera();

	public var gf:UNOSprite;
	public var logo:UNOSprite;
	public var enter:UNOSprite;
	public var ng:FlxSprite;

	public var introTexts:FlxSpriteGroup = new FlxSpriteGroup();

	var texts:Array<Alphabet>;

	public static var skipped:Bool = false;

	public var pressed(default, null):Bool = false;

	public var rTexts:Array<String>;

	var selectedText:Array<String>;

    override public function create() {
        super.create();

		FlxG.cameras.add(madafakingCam);

		CoolUtil.playMusic('freakyMenu', 1, true, {fadeIn: true});

		add(logo = new UNOSprite(-150, -100, 'menus/title/logo', {type: 'anim', anims: ['bump'], loop: false}));

		add(gf = new UNOSprite(512, 50, 'menus/title/gf', {type: 'anim', anims: ['danceLeft', 'danceRight'], loop: false}));

		add(enter = new UNOSprite(100, 576, 'menus/title/enter', {type: 'anim', anims: ['idle', 'pressed']}));
		enter.playAnim('idle');

		if (skipped)
		{
			madafakingCam.flash(0xFFFFFFFF, 1);
		}
		else
		{
			add(ng = new FlxSprite().loadGraphic(Paths.image('menus/title/ng')));
			ng.scale.set(0.8, 0.8);
			ng.updateHitbox();
			ng.screenCenter().y += 150;
			ng.visible = false;

			getRandomText();

			for (e in [logo, gf, enter])
				e.visible = false;

			add(introTexts);

			texts = [];
		}
    }

    override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			if (!skipped)
				skip();
			else
			{
				if (!pressed)
				{
					pressed = true;

					enter.playAnim('pressed', true);
					FlxG.sound?.play(Paths.sound('menu/confirm'), 0.75, false);
					madafakingCam.flash(0xFFFFFFFF, 1, null, true);
				}
			}
		}
	}

	public function getRandomText():Void
	{
		rTexts = [];

		if (!Paths.exists('data/introTexts.txt'))
		{
			selectedText = ['Why did you deleted', 'the introTexts.txt?'];
			return;
		}

		var text:String = Assets.getText(Paths.txt('data/introTexts'));

		if (text == null || text.trim() == '')
		{
			selectedText = ['Can you add something', 'in introTexts.txt pls?'];
			return;
		}

		rTexts = CoolUtil.sliceFromLine(text);

		if (rTexts == null || rTexts.length == 0)
		{
			selectedText = ['Absolutely', 'Nothing'];
			return;
		}

		var finalText:Array<String> = rTexts[FlxG.random.int(0, rTexts.length - 1)].split('--');

		if (finalText.length < 2)
			finalText[1] = ' ';

		if (finalText[0] == '')
			finalText[0] = ' ';

		if (finalText[1] == '')
			finalText[1] = ' ';

		selectedText = [finalText[0], finalText[1]];
	}

	override public function beatHit(b:Int):Void
	{
		super.beatHit(b);

		logo.bump();

		if (b % 2 == 0 || b % 2 == 1)
			gf.bump();

		if (skipped)
			return;

		switch (b)
		{
			case 1:
				createText('ninjamuffin99', -210);
				createText('phantomArcade', -130);
				createText('kawaisprite', -50);
				createText('evilsk8r', 30);

			case 3:
				createText('presents', 110);

			case 4:
				removeTexts();

			case 5:
				createText('absolutely not', -200);
				createText('associated with', -130);

			case 7:
				createText('newgrounds', -60);
				ng.visible = true;

			case 8:
				remove(ng);
				ng.destroy();
				removeTexts();

			case 9:
				createText(selectedText[0], -100);

			case 11:
				createText(selectedText[1], 0);

			case 12:
				removeTexts();

			case 13:
				createText('Friday', -110);

			case 14:
				createText('Night', -35);

			case 15:
				createText("Funkin'", 40, 20);

			case 16:
				skip();
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		skipped = true;
	}

	public function skip()
	{
		if (skipped)
			return;

		skipped = true;

		removeTexts();

		madafakingCam.flash(0xFFFFFFFF, 3);

		for (e in [logo, gf, enter])
			e.visible = true;
	}

	public function createText(text:String = '', offset:Float = 0, extraOff:Float = 0)
	{
		if (skipped)
			return;

		var alphabet:Alphabet = new Alphabet(0, 0, text);
		alphabet.screenCenter().y += offset;
		alphabet.x += extraOff;
		introTexts.add(alphabet);
		texts.push(alphabet);
	}

	public function removeTexts()
	{
		if (texts == null || texts.length == 0)
		{
			Logs.send('Texts already been deleted gng', {type: Warning});

			return;
		}
	
		for (alphabet in texts)
			if (alphabet != null)
			{
				introTexts.remove(alphabet, true);
				alphabet.destroyAlphabet();
			}

		texts.resize(0);
	}
}