package undertale.backend.utils;

import haxe.io.Bytes;
import openfl.utils.ByteArray;
#if(sys || (js && hxnodejs))
import sys.FileSystem;
import sys.io.File;
#else
import openfl.utils.Assets as OpenFlAssets;
#end

@:publicFields class FileUtil
{
	public static inline function exists(path:String):Bool
	{
		return #if (sys || (js && hxnodejs)) FileSystem.exists(path) #else OpenFlAssets.exists(path) #end;
	}

    public static inline function readDirectory(path:String):Array<String> {
		#if (sys || (js && hxnodejs))
        return FileSystem.readDirectory(path);
        #else
        return [];
        #end
    }

	public static inline function getText(path:String):String
	{
		return #if (sys || (js && hxnodejs)) File.getContent(path) #else OpenFlAssets.getText(path) #end;
	}

	public static inline function getBytes(path:String):Bytes
	{
		return #if (sys || (js && hxnodejs)) File.getBytes(path) #else Bytes.ofData(OpenFLAssets.getBytes(path)) #end;
	}

	public static inline function getByteArray(path:String):ByteArray
	{
		return #if (sys || (js && hxnodejs)) ByteArray.fromBytes(File.getBytes(path)) #else OpenFLAssets.getBytes(path) #end;
	}

	public static function saveBytes(path:String, bytes:Bytes)
	{
		try {
			#if (sys || (js && hxnodejs))
			File.saveBytes(path, bytes);
			#else
			throw 'saveBytes is not supported in non-sys platform!';
			#end
		} catch (e:Dynamic) {
			trace('Error saving bytes to "${path}": ${e.toString()}');
        }
	}

	public static function saveText(path:String, text:String)
	{
		try {
			#if (sys || (js && hxnodejs))
			File.saveContent(path, text);
			#else
			throw 'saveText is not supported in non-sys platform!';
			#end
		} catch (e:Dynamic) {
			trace('Error saving text to "${path}": ${e.toString()}');
        }
	}
}