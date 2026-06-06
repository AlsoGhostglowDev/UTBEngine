package undertale.backend;

//TODO: `mods` folder support & changing `assets` folder
@:publicFields class Paths
{
	public static inline var ASSETS_FOLDER:String = "assets";

	static inline function image(key:String):String {
		return '$ASSETS_FOLDER/images/$key.png';
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
		for (script in FileUtil.readDirectory(dir)) {
			if (isScript(script) || (checkForPacks && isScriptPack(script))) {
				scripts.push(script);
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
