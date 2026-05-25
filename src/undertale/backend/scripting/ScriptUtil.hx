package undertale.backend.scripting;

#if macro
import haxe.macro.Context;
#end

#if HSCRIPT_ALLOWED
import hscript.HEnum;
import hscript.utils.UnsafeReflect;
import hscript.Expr;
#end

class ScriptUtil {
	public static var defines(get, null):Map<String, Dynamic>;
	private static inline function get_defines() return __getDefines();
	private static macro function __getDefines() {
		#if display
		return macro $v{[]};
		#else
		return macro $v{Context.getDefines()};
		#end
	}

    public static inline function resolveAbstract(name:String):Dynamic {
        return Type.resolveClass(name + "_HSC");
    }

	public static function hTypeof(obj:Dynamic):String {
		switch (Type.typeof(obj)) {
			case TNull: return "Null";
			case TFloat: return "Float";
			case TInt: return "Int";
			case TBool: return "Bool";
			case TObject: return "Object";
			case TFunction: return "Function";
			case TClass(cls):
				var clsName:String = Type.getClassName(cls);
				switch (clsName) {
					case "hscript.CustomClassHandler": // Scripted Class
						return "CustomClassHandler<" + Reflect.getProperty(obj, "name") + ">";

					case "hscript.CustomClass": // Scripted Class instance
						return "CustomClass<" + Reflect.getProperty(obj, "className") + ">";

					case "hscript.HEnum": // Scripted Enum
						var fields:Null<Array<String>> = Reflect.fields(obj.enumValues);
						var enumName:Null<String> = null;

						/*
						 * Since a name field doesn't exist for HEnum, we check the first constructor
						 * in the enum and use that, since that has a name field.
						 */
						if (fields != null && fields.length > 0)
						{
							for (item in fields)
							{
								var henumInst:HEnumValue = Reflect.getProperty(obj.enumValues, item);
								enumName = henumInst.enumName;
								break;
							}
						}
						return "HEnum" + (enumName != null ? ("<" + enumName + ">") : "");

					case "hscript.HEnumValue": // Scripted Enum value
						return "HEnumValue<" + Reflect.field(obj, "enumName") + ">";

					default:
						return clsName;
				}

			case TEnum(enm): return "Enum<" + Type.getEnumName(enm) + ">";
			default: return "Unknown";
		}

        return "Unknown";
	}

	public static function getImportsFromModule(content:String, ?name:String = "hscript"):Map<String, Dynamic> {
		var retVal:Map<String, Dynamic> = new Map<String, Dynamic>();

		var parser:hscript.Parser = new hscript.Parser();
		parser.allowJSON = parser.allowMetadata = parser.allowTypes = parser.allowRegex = true;
		parser.preprocessorValues = ScriptUtil.defines;

		var interp:hscript.Interp = new hscript.Interp();
		interp.allowStaticVariables = interp.allowPublicVariables = false;

		try {
			parser.line = 1; // Reset the parser position.
			var parsedModules:Array<ModuleDecl> = parser.parseModule(content, name);

			for (module in parsedModules) {
				switch (module) {
					case DImport(path, isWildcard):
						var _import = importResolve(path.join('.'));
						retVal.set(_import.name, _import.value);
					default:
						//
				}
			}
		} catch (e) {
			trace('Error on import.hx: ' + Std.string(e));
		}

		return retVal;
	}

	public static function importResolve(clsName:String, ?aliasAs:String):{name:Null<String>, value:Dynamic}
	{
		var splitClassName:Array<String> = [for (e in clsName.split(".")) StringTools.trim(e)];
		var realClassName = splitClassName.join(".");
		var claVarName = splitClassName[splitClassName.length - 1];
		var toSetName = aliasAs != null ? aliasAs : claVarName;
		var oldClassName = realClassName;
		var oldSplitName = splitClassName.copy();

		function doImportResolve(__clsName:String):Null<Dynamic> {
			var _cl = Type.resolveClass(__clsName);
			if (_cl == null) _cl = Type.resolveClass('${__clsName}_HSC');
			return _cl;
		}

		var cl = doImportResolve(realClassName);
		var en = Type.resolveEnum(realClassName);
		// trace(realClassName, cl, en, splitClassName);

		// Allow for flixel.ui.FlxBar.FlxBarFillDirection;
		if (cl == null && en == null) {
			if (splitClassName.length > 1) {
				splitClassName.splice(-2, 1); // Remove the last last item
				realClassName = splitClassName.join(".");

				cl = doImportResolve(realClassName);
				en = Type.resolveEnum(realClassName);
				// trace(realClassName, cl, en, splitClassName);
			}
		}

		if (cl == null && en == null) {
			// allows for static imports like "haxe.io.Path.normalize"
			var clPth:Array<String> = oldSplitName.copy();
			var funcName:String = clPth.pop();
			var statField:Dynamic = Reflect.getProperty(Type.resolveClass(StringTools.trim(clPth.join("."))), funcName);

			if (statField != null) {
				return {name: (toSetName != null && toSetName.length > 0 ? toSetName : funcName), value: statField};
			}
		} else {
			/*
			if(toSetName != claVarName && !Tools.isUppercase(toSetName)) {
				error(ECustom("Type aliases must start with an uppercase letter"));
				return null;
			}
			*/

			if (en != null) { // ENUM!!!!
				var enumThingy:HEnum = {};
				for (c in en.getConstructors()) {
					try {
						// UnsafeReflect.setField(enumThingy, c, en.createByName(c));
						enumThingy.setEnum(c, en.createByName(c));
					} catch (e) {
						try {
							// UnsafeReflect.setField(enumThingy, c, UnsafeReflect.field(en, c));
							enumThingy.setEnum(c, UnsafeReflect.field(en, c));
						}
						catch (ex) {
							throw e;
						}
					}
				}

				return {name: toSetName, value: enumThingy};
			} else { // Standard class
				return {name: toSetName, value: cl};
			}
		}

		return {name: null, value: null};
	}
}