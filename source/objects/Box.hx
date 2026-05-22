package objects;

import flixel.group.FlxSpriteGroup;

class Box extends FlxSpriteGroup {
    public var left:FlxSprite;
    public var right:FlxSprite;
    public var top:FlxSprite;
    public var bottom:FlxSprite;
    public var background:FlxSprite;

    public var boxWidth(default, set):Float = 0;
	public var boxHeight(default, set):Float = 0;

    function set_boxWidth(value:Float) {
        if (value != boxWidth) updateSize(value, boxHeight);
        return boxWidth = value;
    }

    function set_boxHeight(value:Float) {
		if (value != boxHeight) updateSize(boxWidth, value);
        return boxHeight = value;
    }

    public function new(x:Float, y:Float, width:Float, height:Float) {
        super(x, y);

        background = new FlxSprite(0, 0).makeGraphic(1, 1, 0xFFFFFFFF);
        background.color = 0xFF000000;
        add(background);

        left = new FlxSprite(0, 0).makeGraphic(1, 1, 0xFFFFFFFF);
		right = new FlxSprite(0, 0).makeGraphic(1, 1, 0xFFFFFFFF);
		top = new FlxSprite(0, 0).makeGraphic(1, 1, 0xFFFFFFFF);
		bottom = new FlxSprite(0, 0).makeGraphic(1, 1, 0xFFFFFFFF);

        for (o in [left, right, top, bottom]) add(o);

        updateSize(width, height);
    }

    public function updateSize(?width:Float, ?height:Float) {
        @:bypassAccessor boxWidth = width ?? boxWidth;
        @:bypassAccessor boxHeight = height ?? boxHeight;

        if (width != null || height != null) {
			left.scale.set(5, height);
			right.scale.set(5, height);
			top.scale.set(width, 5);
			bottom.scale.set(width + 5, 5);
            for (m in [left, right, top, bottom]) m.updateHitbox();

            right.setPosition(x + top.width, y);
            bottom.setPosition(x, y + left.height);
        }
    }

    public var __tween:FlxTween;
    public function tweenSize(width:Float, height:Float, ?duration:Float = 0.15, tweenOptions:TweenOptions) {
        final __onComplete = tweenOptions.onComplete;
        tweenOptions.onComplete = twn -> {
            if (__onComplete != null)
                __onComplete(twn);

            __tween = null;
        }

		if (__tween != null) __tween.cancel();
        __tween = FlxTween.tween(this, {boxWidth: width, boxHeight: height}, duration, tweenOptions);
    }
}