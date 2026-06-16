package undertale.objects;

import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;

class BattleButton extends flixel.group.FlxSpriteGroup {
    /**
     * Called when the tracker selected the button.
     * First argument is true only once and acts like
     * `FlxG.keys.justPressed`.
     */
    public var onPressed:Bool->Void;

    /**
     * Called when the tracker is overlapping the button.
     * First argument is true only once and acts like
     * `FlxG.keys.justPressed`.
     */
	public var onOverlap:Bool->Void;

    /**
     * This is called whenever the tracker overlaps the button.
     * To consider it as pressed, this function needs to return `true`.
     */
    public var checkPressed:Void->Bool;

    /**
     * shortcut to `scale`. Set this to set both sprites at once.
     */
	public var size(get, set):FlxPoint;

    /**
     * The object to check for overlaps
     */
	public var tracker:FlxBasic;

    /**
     * The button's bg.
     */
    public var bg:FlxSprite;

    /**
     * The button's overlay to the bg.
     */
    public var overlay:FlxSprite;

    public override function new(x:Float, y:Float, ?tracker:FlxBasic) {
        super(x, y);
        this.tracker = tracker;

		createImage();
    }

    public var updateAnimations:Bool = true;
    public var __isFirstOverlap:Bool = false;
    public var __isFirstPress:Bool = false;
    public override function update(elapsed:Float) {
        super.update(elapsed);

        if(!this.alive || !this.active) return;

        //Overlap obj
        if(tracker != null && FlxG.overlap(this, tracker)) {
			if(onOverlap != null) {
                if(__isFirstOverlap && updateAnimations) {
                    this.playAnim("selected");
                }
				this.onOverlap(__isFirstOverlap);
				__isFirstOverlap = false;
            }
        } else {
            if(!__isFirstOverlap && updateAnimations) {
                this.playAnim("normal");
            }
			__isFirstOverlap = true;
        }

        //Overlap & pressed
        if(tracker != null && FlxG.overlap(this, tracker) &&
            (checkPressed != null && checkPressed() == true)) {
			if (onPressed != null) {
				this.onPressed(__isFirstPress);
				__isFirstPress = false;
            }
        } else {
			__isFirstPress = true;
        }
    }

	/**
	 * Loads images onto the bg and overlay. Sprites with no replacement
     * @param   bgImage         The string path to the new bg image. If null,
     *                          then it will default to the default empty button.
	 * @param   overlayImage    The string path to the new overlay image. If null,
	 *                          then it will default to the default fight button.
	 */
    public function loadImage(?bgImage:Null<String>, ?overlayImage:Null<String>) {
        if(bgImage == null) bgImage = "engine/battle/ui/buttons/empty_button";
		if(overlayImage == null) overlayImage = "engine/battle/ui/buttons/fight_text_button";

        //button bg
        for(i in 0...2) {
            var obj:FlxSprite = (i == 0 ? bg : overlay);
			var image:String = (i == 0 ? bgImage : overlayImage);
			var imageGraphic:FlxGraphic = FlxGraphic.fromAssetKey(Paths.image(image));

            //If there is an xml to the button graphic, use that,
            //Else we just resort to two frames of animation.
			if(FileUtil.exists(Paths.imageXml(image))) {
				obj.frames = Paths.getSparrowAtlas(image);
				obj.updateHitbox();

				obj.animation.addByNames("normal", ["normal"], 30, true);
				obj.animation.addByNames("selected", ["selected"], 30, true);
				obj.animation.play("normal");
            } else {
				obj.loadGraphic(imageGraphic, true, Math.floor(imageGraphic.width / 2), imageGraphic.height);
				obj.updateHitbox();

				obj.animation.add("normal", [0], 1, true);
				obj.animation.add("selected", [1], 1, true);
				obj.animation.play("normal");
            }
        }
    }

    public function createImage() {
        if(this.bg == null) {
			bg = new FlxSprite(this.x, this.y);
			add(bg);
        }
        if(this.overlay == null) {
			overlay = new FlxSprite(this.x, this.y);
			add(overlay);
        }
    }

    /**
     * Plays an animation on both the bg and overlay sprites.
     */
	public inline function playAnim(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
        this.bg.animation.play(name, force, reversed, frame);
		this.overlay.animation.play(name, force, reversed, frame);
    }

	function get_size():FlxPoint {
        return this.bg.scale;
    }

	function set_size(val:FlxPoint):FlxPoint {
		this.bg.scale.set(val.x, val.y);
		this.overlay.scale.set(val.x, val.y);
        return this.bg.scale;
    }
}