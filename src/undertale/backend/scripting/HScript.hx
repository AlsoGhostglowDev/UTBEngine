package undertale.backend.scripting;

#if HSCRIPT_ALLOWED
import undertale.backend.scripting.ScriptUtil;

import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import hscript.Printer;
#end

typedef HScriptOptions = {
	var ?parent:Dynamic;
	@:default(false) var ?ignoreErrors:Bool;
}

typedef Conditional = {
	var name:String;
	@:default(true) var ?value:Dynamic;
}

class HScript extends flixel.FlxBasic {
	#if HSCRIPT_ALLOWED
	public static var staticVariables:Map<String, Dynamic> = [];

	//Default imports, handled by `import.hx`
	public static var defaultImports:Map<String, Dynamic> = new Map();

	public var parser:Parser;
	public var interp:Interp;
	public var expr:Expr;

	/**
	 * The script's path.
	 */
	public var path:String;

	/**
	 * The script's options, like if it
	 * should ignore errors, custom flags, etc.
	 */
	public var options:HScriptOptions;

	/**
	 * A shortcut to the script's parent object.
	 */
	public var parent(get, set):Dynamic;
	public inline function get_parent():Dynamic { return interp.scriptObject; }
	public function set_parent(val:Dynamic):Dynamic {
		if(interp == null) return null;

		interp.scriptObject = val;
		if(val.variables != null) interp.publicVariables = val.variables;

		return interp.scriptObject;
	}

	override public function new(path:String, ?options:HScriptOptions) {
		super();

		this.path = path;

		this.options = options;
		this.options.ignoreErrors ??= false;

		if(parser == null) initParser();
		if(interp == null) initInterp();

		if (this.options.parent != null)
			this.parent = this.options.parent;

		preset();
	}

	public inline function runFile(path:String):Dynamic {
		#if sys
		return this.run(sys.io.File.getContent(path));
		#else
		return null;
		#end
	}

	public function run(code:String):Dynamic {
		try {
			parser.line = 1;
			expr = parser.parseString(code, this.path);

			interp.execute(expr);
			call("new");

			this.active = true;
		} catch(e) {
			if (this.options.ignoreErrors == null || !this.options.ignoreErrors) {
				trace('Error on haxe script "' + this.path + '": ' + Std.string(e));
			}
			this.active = false;
		}

		return null;
	}

	public inline function initParser() {
		parser = new Parser();
		parser.allowJSON = parser.allowMetadata = parser.allowTypes = parser.allowRegex = true;

		parser.preprocessorValues = ScriptUtil.defines;
	}

	public inline function initInterp() {
		interp = new Interp();
		interp.allowStaticVariables = interp.allowPublicVariables = true;
		interp.staticVariables = HScript.staticVariables;

		interp.errorHandler = onError;
		interp.warnHandler = onWarn;
		//interp.importFailedCallback = onImportFailed;
	}

	public function preset() {
		if(this.interp == null) return;

		interp.variables.set("__script__", this);
		for (tag => value in defaultImports) interp.variables.set(tag, value);

		// Default classes //

		interp.variables.set("Math", Math);
		interp.variables.set("Std", Std);
		interp.variables.set("StringTools", StringTools);
		interp.variables.set("Reflect", Reflect);
		interp.variables.set("Type", Type);
		interp.variables.set("Reflect", Reflect);
		interp.variables.set("Date", Date);
		interp.variables.set("DateTools", DateTools);
		#if sys
		interp.variables.set("Sys", Sys);
		interp.variables.set("File", sys.io.File);
		interp.variables.set("FileSystem", sys.FileSystem);
		#end

		//Battle Engine stuff
		interp.variables.set("Paths", undertale.backend.Paths);
		interp.variables.set("Preferences", undertale.backend.Preferences);
		interp.variables.set("BaseState", undertale.backend.BaseState);
		interp.variables.set("PlayState", undertale.game.PlayState);

		#if flixel
		interp.variables.set("FlxG", flixel.FlxG);
		interp.variables.set("FlxSprite", flixel.FlxSprite);
		interp.variables.set("FlxText", flixel.text.FlxText);
		interp.variables.set("FlxTween", flixel.tweens.FlxTween);
		interp.variables.set("FlxEase", flixel.tweens.FlxEase);

		interp.variables.set("FlxMath", flixel.math.FlxMath);
		interp.variables.set("FlxSound", flixel.sound.FlxSound);

		interp.variables.set("FlxGroup", flixel.group.FlxGroup);
		interp.variables.set("FlxTypedGroup", flixel.group.FlxGroup.FlxTypedGroup);
		interp.variables.set("FlxSpriteGroup", flixel.group.FlxSpriteGroup);

		interp.variables.set("FlxAxes", ScriptUtil.resolveAbstract("flixel.util.FlxAxes"));
		interp.variables.set("FlxColor", ScriptUtil.resolveAbstract("flixel.util.FlxColor"));
		#end

		// End of default imports //

		interp.variables.set("__type__", ScriptUtil.hTypeof);
		interp.variables.set("__close__", function(?destroy:Bool = true) {
			this.active = false;

			if(destroy) this.destroy();
		});
	}

	public function onError(e:Error) {
		trace("[ERROR] " + Printer.errorToString(e));
	}

	public function onWarn(e:Error) {
		trace("[WARNING] " + Printer.errorToString(e));
	}

	override public function destroy() {
		expr = null;
		interp = null;
		parser = null;

		this.active = false;
		super.destroy();
	}

	public inline function get(name:String):Dynamic {
		return (this.interp != null ? this.interp.variables.get(name) : null);
	}

	public inline function set(variable:String, data:Dynamic) {
		if(this.interp != null) this.interp.variables.set(variable, data);
	}

	public function call(func:String, ?args:Array<Dynamic>):Dynamic {
		if (interp == null || this.active == false) return null;

		var functionVar = interp.variables.get(func);
		if (functionVar == null || !Reflect.isFunction(functionVar)) return null;
		return (args != null && args.length > 0) ? Reflect.callMethod(null, functionVar, args) : functionVar();
	}
	#end
}