package undertale.game.ui;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.math.FlxMath;

class HealthBar extends Bar {
    var __health(get, never):Int;
	var __karma(get, never):Int;
	var __maxHealth(get, never):Int;
    function get___health() return Player.health;
    function get___karma() return Player.karma;
    function get___maxHealth() return Player.maxHealth;

    public var karmaBar:FlxSprite;

    public function new(x:Float, y:Float, maxHealth:Float) {
        super(x, y, null, null, this, '__health', {min: 0, max: maxHealth});
		empty.makeGraphic(__maxHealth * 2, 25, 0xFFD31200);
		fill.makeGraphic(__maxHealth * 2, 25, 0xFFFFFF00);

        karmaBar = new FlxSprite(0, 0);
		karmaBar.makeGraphic(__maxHealth * 2, 25, 0xFFFF00FF);

        remove(fill);
        add(karmaBar);
        add(fill);

        regenClips();
    }

    override function regenClips() {
        super.regenClips();

        if (karmaBar != null)
            karmaBar.clipRect = new FlxRect(0, 0, Std.int(karmaBar.width), Std.int(karmaBar.height));
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

		var karmaPercent = (((__health + __karma) - bounds.min) / (bounds.max - bounds.min)) * 100;
		var fillSize:Float = 0;
		if (leftToRight)
			fillSize = FlxMath.lerp(0, karmaBar.width, karmaPercent / 100);
		else
			fillSize = FlxMath.lerp(0, karmaBar.width, 1 - karmaPercent / 100);

		karmaBar.clipRect.width = fillSize;
		karmaBar.clipRect = karmaBar.clipRect;
	}
}