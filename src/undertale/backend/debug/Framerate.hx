package undertale.backend.debug;

import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Bitmap;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib.getTimer;

import flixel.math.FlxMath;

#if cpp
import cpp.vm.Gc;
#elseif hl
import hl.Gc;
#elseif java
import java.vm.Gc;
#elseif neko
import neko.vm.Gc;
#end

enum abstract DebugMode(Int) {
    var NONE = 0;
    var FPS_ONLY = 1;
    var MEM_ONLY = 2;
    var ALL = 3;
}

/*
 * FPS and Memory stuff for debugging.
 * Mostly from CNE's API.
 */

class Framerate extends Sprite {
	public var mode:DebugMode = ALL;

    //Background
    public var bitmap:BitmapData;
    public var bgSpr:Bitmap;

    //Fps
	public var fpsText:TextField;

    //Memory
	public var memText:TextField;

	public var memory(get, never):Float;
	public var memoryPeak:Float = 0;

    public override function new() {
		super();

		this.x = 2;
		this.y = 2;

		if (bitmap == null) {
            bitmap = new BitmapData(1, 1, 0xFF000000);
			bgSpr = new Bitmap(bitmap);
			bgSpr.alpha = 0.2;
			addChild(bgSpr);
        }

        if(fpsText == null) {
			fpsText = new TextField();
			fpsText.autoSize = LEFT;
			fpsText.x = 0;
			fpsText.y = 0;
			fpsText.text = "FPS";
			fpsText.multiline = fpsText.wordWrap = false;
			fpsText.defaultTextFormat = new TextFormat(null, 10, -1);
			fpsText.selectable = false;
			addChild(fpsText);
        }

        if(memText == null) {
			memText = new TextField();
			memText.autoSize = LEFT;
			memText.x = fpsText.x;
			memText.y = fpsText.y + fpsText.height;
			memText.text = "MEM";
			memText.multiline = memText.wordWrap = false;
			memText.defaultTextFormat = new TextFormat(null, 10, -1);
			memText.selectable = false;
			addChild(memText);
        }
    }

    //Fps backend
	public var lastFPS:Float = 0;

	private var frameCount:Int = 0;
	private var accumulatedTime:Float = getTimer();
	private final updateInterval:Float = 1 / 15;
	private var lastUpdateTime:Float = 0;

	public override function __enterFrame(t:Int)
	{
		if (this.alpha < 0.05) return;
		super.__enterFrame(t);

        //FPS
        if(this.mode == ALL || this.mode == FPS_ONLY) {
            frameCount++;

            final timer = getTimer();
            final time = timer - accumulatedTime;
            accumulatedTime = timer;

            lastFPS = FlxMath.lerp(lastFPS, time <= 0 ? 0 : (1000 / time * frameCount), 1.0 - Math.pow(0.75, time * 0.06));

            fpsText.text = "FPS: " + Std.string(Math.round(lastFPS));
            lastUpdateTime = frameCount = 0;
        }

        //Memory
		if (this.mode != ALL && this.mode != MEM_ONLY) return;
        if(memory > memoryPeak) memoryPeak = memory;
		memText.text = "MEM: " + getSizeString(memory) + " / " + getSizeString(memoryPeak);
	}

    public inline function get_memory():Float {
		#if cpp
		return Gc.memInfo64(Gc.MEM_INFO_USAGE);
		#elseif hl
		return Gc.stats().currentMemory;
		#elseif sys
		return cast(cast(openfl.system.System.totalMemory, UInt), Float);
		#else
		return 0;
		#end
    }

	// https://github.com/CodenameCrew/CodenameEngine/blob/main/source/funkin/backend/utils/CoolUtil.hx#L332
	public static final sizeLabels:Array<String> = ["B", "KB", "MB", "GB", "TB"];
	public static function getSizeString(size:Float):String {
		var rSize:Float = size;
		var label:Int = 0;
		while (rSize >= 1024 && label < sizeLabels.length - 1) {
			label++;
			rSize /= 1024;
		}

		var sizeStr:String = Std.string(Std.int((rSize % 1) * 100));
		return (Std.int(rSize) + ((label <= 1) ? "" : "." + StringTools.lpad(sizeStr, "0", sizeStr.length) + sizeLabels[label]));
	}
}