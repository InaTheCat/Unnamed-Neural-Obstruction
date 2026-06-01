package;

import haxe.io.Bytes;
import haxe.io.Path;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

#if disable_preloader_assets
@:dox(hide) class ManifestResources {
	public static var preloadLibraries:Array<Dynamic>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;

	public static function init (config:Dynamic):Void {
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
	}
}
#else
@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

			if(!StringTools.endsWith (rootPath, "/")) {

				rootPath += "/";

			}

		}

		if (rootPath == null) {

			#if (ios || tvos)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif (emscripten || webassembly)
			rootPath = "";
			#elseif (console || sys)
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		data = '{"name":null,"assets":"aoy4:pathy36:assets%2Fdata%2Fcharacters%2Fbf.jsony4:sizei675y4:typey4:TEXTy2:idR1y7:preloadtgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R4R5R7R6tgoR0y37:assets%2Fimages%2Fcharacters%2Fbf.pngR2i1390447R3y5:IMAGER5R8R6tgoR0y37:assets%2Fimages%2Fcharacters%2Fbf.xmlR2i46873R3R4R5R10R6tgoR0y38:assets%2Fimages%2Fcharacters%2Fdad.pngR2i576049R3R9R5R11R6tgoR0y38:assets%2Fimages%2Fcharacters%2Fdad.xmlR2i15572R3R4R5R12R6tgoR0y44:assets%2Fimages%2Fgame%2Fnotes%2Fdefault.pngR2i632480R3R9R5R13R6tgoR0y44:assets%2Fimages%2Fgame%2Fnotes%2Fdefault.xmlR2i8201R3R4R5R14R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R15R6tgoR0y48:assets%2Fimages%2Fmenus%2Fmainmenu%2Fcredits.pngR2i24912R3R9R5R16R6tgoR0y48:assets%2Fimages%2Fmenus%2Fmainmenu%2Fcredits.xmlR2i1863R3R4R5R17R6tgoR0y47:assets%2Fimages%2Fmenus%2Fmainmenu%2Fdonate.pngR2i24955R3R9R5R18R6tgoR0y47:assets%2Fimages%2Fmenus%2Fmainmenu%2Fdonate.xmlR2i1413R3R4R5R19R6tgoR0y49:assets%2Fimages%2Fmenus%2Fmainmenu%2Ffreeplay.pngR2i30078R3R9R5R20R6tgoR0y49:assets%2Fimages%2Fmenus%2Fmainmenu%2Ffreeplay.xmlR2i1885R3R4R5R21R6tgoR0y48:assets%2Fimages%2Fmenus%2Fmainmenu%2Foptions.pngR2i27392R3R9R5R22R6tgoR0y48:assets%2Fimages%2Fmenus%2Fmainmenu%2Foptions.xmlR2i1427R3R4R5R23R6tgoR0y53:assets%2Fimages%2Fmenus%2Fmainmenu%2Fstory%20mode.pngR2i44172R3R9R5R24R6tgoR0y53:assets%2Fimages%2Fmenus%2Fmainmenu%2Fstory%20mode.xmlR2i1462R3R4R5R25R6tgoR0y36:assets%2Fimages%2Fmenus%2FmenuBG.pngR2i431289R3R9R5R26R6tgoR0y45:assets%2Fimages%2Fstages%2Fdefault%2Fback.pngR2i11996R3R9R5R27R6tgoR0y49:assets%2Fimages%2Fstages%2Fdefault%2Fcurtains.pngR2i112181R3R9R5R28R6tgoR0y46:assets%2Fimages%2Fstages%2Fdefault%2Ffloor.pngR2i112627R3R9R5R29R6tgoR0y52:assets%2Fimages%2Fstages%2Fdefault%2Fstage_light.pngR2i7092R3R9R5R30R6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R4R5R31R6tgoR0y48:assets%2Fsongs%2FPremeditated%2Fchart%2Fcne.jsonR2i152955R3R4R5R32R6tgoR0y49:assets%2Fsongs%2FPremeditated%2Fchart%2Fhard.jsonR2i77394R3R4R5R33R6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R34R6tgoR2i8220R3y5:MUSICR5y26:flixel%2Fsounds%2Fbeep.mp3y9:pathGroupaR36y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R35R5y28:flixel%2Fsounds%2Fflixel.mp3R37aR39y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i6840R3y5:SOUNDR5R38R37aR36R38hgoR2i33629R3R41R5R40R37aR39R40hgoR2i15744R3y4:FONTy9:classNamey35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R42R43y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i222R3R9R5R48R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i484R3R9R5R49R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

	}


}

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_characters_bf_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_characters_bf_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_characters_bf_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_characters_dad_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_characters_dad_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_game_notes_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_game_notes_default_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_credits_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_credits_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_donate_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_donate_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_freeplay_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_freeplay_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_options_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_options_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_story_mode_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_story_mode_xml extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_menus_menubg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_back_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_curtains_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_floor_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_stage_light_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_songs_premeditated_chart_cne_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_songs_premeditated_chart_hard_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/data/characters/bf.json") @:noCompletion #if display private #end class __ASSET__assets_data_characters_bf_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/characters/bf.png") @:noCompletion #if display private #end class __ASSET__assets_images_characters_bf_png extends lime.graphics.Image {}
@:keep @:file("assets/images/characters/bf.xml") @:noCompletion #if display private #end class __ASSET__assets_images_characters_bf_xml extends haxe.io.Bytes {}
@:keep @:image("assets/images/characters/dad.png") @:noCompletion #if display private #end class __ASSET__assets_images_characters_dad_png extends lime.graphics.Image {}
@:keep @:file("assets/images/characters/dad.xml") @:noCompletion #if display private #end class __ASSET__assets_images_characters_dad_xml extends haxe.io.Bytes {}
@:keep @:image("assets/images/game/notes/default.png") @:noCompletion #if display private #end class __ASSET__assets_images_game_notes_default_png extends lime.graphics.Image {}
@:keep @:file("assets/images/game/notes/default.xml") @:noCompletion #if display private #end class __ASSET__assets_images_game_notes_default_xml extends haxe.io.Bytes {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/menus/mainmenu/credits.png") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_credits_png extends lime.graphics.Image {}
@:keep @:file("assets/images/menus/mainmenu/credits.xml") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_credits_xml extends haxe.io.Bytes {}
@:keep @:image("assets/images/menus/mainmenu/donate.png") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_donate_png extends lime.graphics.Image {}
@:keep @:file("assets/images/menus/mainmenu/donate.xml") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_donate_xml extends haxe.io.Bytes {}
@:keep @:image("assets/images/menus/mainmenu/freeplay.png") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_freeplay_png extends lime.graphics.Image {}
@:keep @:file("assets/images/menus/mainmenu/freeplay.xml") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_freeplay_xml extends haxe.io.Bytes {}
@:keep @:image("assets/images/menus/mainmenu/options.png") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_options_png extends lime.graphics.Image {}
@:keep @:file("assets/images/menus/mainmenu/options.xml") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_options_xml extends haxe.io.Bytes {}
@:keep @:image("assets/images/menus/mainmenu/story mode.png") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_story_mode_png extends lime.graphics.Image {}
@:keep @:file("assets/images/menus/mainmenu/story mode.xml") @:noCompletion #if display private #end class __ASSET__assets_images_menus_mainmenu_story_mode_xml extends haxe.io.Bytes {}
@:keep @:image("assets/images/menus/menuBG.png") @:noCompletion #if display private #end class __ASSET__assets_images_menus_menubg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/stages/default/back.png") @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_back_png extends lime.graphics.Image {}
@:keep @:image("assets/images/stages/default/curtains.png") @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_curtains_png extends lime.graphics.Image {}
@:keep @:image("assets/images/stages/default/floor.png") @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_floor_png extends lime.graphics.Image {}
@:keep @:image("assets/images/stages/default/stage_light.png") @:noCompletion #if display private #end class __ASSET__assets_images_stages_default_stage_light_png extends lime.graphics.Image {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/songs/Premeditated/chart/cne.json") @:noCompletion #if display private #end class __ASSET__assets_songs_premeditated_chart_cne_json extends haxe.io.Bytes {}
@:keep @:file("assets/songs/Premeditated/chart/hard.json") @:noCompletion #if display private #end class __ASSET__assets_songs_premeditated_chart_hard_json extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/6,1,2/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/6,1,2/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/6,1,2/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/6,1,2/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/6,1,2/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/6,1,2/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end