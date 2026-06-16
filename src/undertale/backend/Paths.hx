package undertale.backend;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;

//TODO: `mods` folder support & changing `assets` folder
@:publicFields class Paths
{
	public static inline var ASSETS_FOLDER:String = "assets";

	// Image related stuff
	static inline function image(key:String):String {
		return '$ASSETS_FOLDER/images/$key.png';
	}

	static inline function imageXml(key:String):String {
		return '$ASSETS_FOLDER/images/$key.xml';
	}

	static inline function getSparrowAtlas(file:String):FlxAtlasFrames {
		var graphic:FlxGraphic = FlxGraphic.fromAssetKey(image('$file.png'));
		return FlxAtlasFrames.fromSparrow(graphic, getPath('images/$file.xml'));
	}

	// Misc

	static inline function getPath(key:String):String {
		return '$ASSETS_FOLDER/$key';
	}

	static inline function font(key:String):String {
		return '$ASSETS_FOLDER/fonts/$key';
	}

	static inline function sound(key:String):String {
		return '$ASSETS_FOLDER/sounds/$key.ogg';
	}

	static inline function music(key:String):String {
		return '$ASSETS_FOLDER/music/$key.ogg';
	}

	static inline function json(key:String):String {
		return '$ASSETS_FOLDER/data/$key.json';
	}

	#if HSCRIPT_ALLOWED
	static inline var scriptExt:String = ".hx";
	static inline var scriptPackExt:String = ".pack";

	static inline function script(scr:String) {
		return '$ASSETS_FOLDER/' + (StringTools.endsWith(scr, scriptExt) ? scr + scriptExt : scr);
	}

	static inline function checkScriptsInDirectory(dir:String, ?checkForPacks:Bool = false):Array<String> {
		var scripts:Array<String> = [];
		for (script in FileUtil.readDirectory('$ASSETS_FOLDER/$dir')) {
			if (isScript(script) || (checkForPacks && isScriptPack(script))) {
				scripts.push(ASSETS_FOLDER + "/" + dir + script);
			}
		}

		return scripts;
	}

	static inline function isScript(scr:String):Bool {
		return StringTools.endsWith(scr, scriptExt);
	}

	static inline function isScriptPack(scr:String):Bool {
		return StringTools.endsWith(scr, scriptPackExt);
	}

	#end
}
