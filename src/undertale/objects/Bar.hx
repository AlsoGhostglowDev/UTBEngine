package undertale.objects;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.math.FlxMath;

class Bar extends FlxSpriteGroup {
    var valueParent:Dynamic;
    var fieldValue:String;
    var value(get, never):Float;
    var bounds:{min:Float, max:Float} = {min: 0, max: 0};

    public var percent(get, never):Float;
    public var leftToRight:Bool = true;

    public var fill:FlxSprite;
    public var empty:FlxSprite;

    function get_value() 
        return Reflect.getProperty(valueParent, fieldValue);

    function get_percent()
        return ((value - bounds.min) / (bounds.max - bounds.min)) * 100;

    public function new(x:Float, y:Float, ?fillGraphic:String, ?emptyGraphic:String, valueParent:Dynamic, fieldValue:String, ?bounds:{min:Float, max:Float}) {
        super(x, y);

        this.valueParent = valueParent;
        this.fieldValue = fieldValue;
        this.bounds = bounds ?? {min: 0, max: 1};

        empty = new FlxSprite().loadGraphic(Paths.image(emptyGraphic ?? ''));
        add(empty);

        fill = new FlxSprite().loadGraphic(Paths.image(fillGraphic ?? ''));
        add(fill);

        regenClips();
    }

    public function regenClips()
        fill.clipRect = new FlxRect(0, 0, Std.int(fill.width), Std.int(fill.height));

    override function update(elapsed:Float) {
        super.update(elapsed);

        var fillSize:Float = 0;
		if(leftToRight) fillSize = FlxMath.lerp(0, fill.width, percent / 100);
		else fillSize = FlxMath.lerp(0, fill.width, 1 - percent / 100);
        
		fill.clipRect.width = fillSize;
        fill.clipRect = fill.clipRect;
    }
}