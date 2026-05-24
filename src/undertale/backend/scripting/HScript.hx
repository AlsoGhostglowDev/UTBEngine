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
	@:default(false) var ?isString:Bool;
	@:default(false) var ?ignoreErrors:Bool;
}

typedef Conditional = {
	var name:String;
	@:default(true) var ?value:Dynamic;
}

class HScript extends flixel.FlxBasic {
	#if HSCRIPT_ALLOWED
	public static var staticVariables:Map<String, Dynamic> = [];

	public static var defaultClasses:Map<String, Dynamic> = [
		//Base level haxe classes
		"Math" => Math, "Std" => Std,
		"StringTools" => StringTools,
		"Reflect" => Reflect, 'Type' => Type,
		'Date' => Date, 'DateTools' => DateTools,
		#if sys
		'Sys' => Sys,
		"File" => sys.io.File,
		"FileSystem" => sys.FileSystem,
		#end

		#if flixel
		//Flixel classes
		"FlxG" => flixel.FlxG,
		"FlxSprite" => flixel.FlxSprite,
		"FlxText" => flixel.text.FlxText,
		"FlxTween" => flixel.tweens.FlxTween,
		"FlxEase" => flixel.tweens.FlxEase,
		"FlxMath" => flixel.math.FlxMath,
		"FlxSound" => flixel.sound.FlxSound,
		"FlxGroup" => flixel.group.FlxGroup,
		"FlxTypedGroup" => flixel.group.FlxGroup.FlxTypedGroup,
		"FlxSpriteGroup" => flixel.group.FlxSpriteGroup,

		"FlxAxes" => ScriptUtil.resolveAbstract("flixel.util.FlxAxes"),
		"FlxColor" => ScriptUtil.resolveAbstract("flixel.util.FlxColor"),
		#end

		"Json" => haxe.Json,
		"Xml" => Xml
	];

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
		this.options ??= {ignoreErrors: false, isString: false};
		this.options.isString ??= false; // Just making sure

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
			if ((this.options.ignoreErrors ?? false) == true) {
				trace('Error on haxe script "' + this.path + '": ' + Std.string(e));
			}
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
		for (tag => value in defaultClasses) interp.variables.set(tag, value);

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