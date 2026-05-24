package undertale.backend.scripting;

#if macro
import haxe.macro.Context;
#end

#if HSCRIPT_ALLOWED
import hscript.HEnum;
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
}