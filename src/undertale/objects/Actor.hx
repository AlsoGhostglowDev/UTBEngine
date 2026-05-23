package undertale.objects;

import sys.io.File;
import tjson.TJSON;
import flixel.group.FlxSpriteGroup;

typedef PartData = {
    var name:String;
    var imageFile:String;
    var offsetX:Float;
    var offsetY:Float;
    var animationOffsets:Map<String, Array<Float>>;
}

class Actor extends FlxSpriteGroup {
    public var animationOffsets:Map<String, {x:Float, y:Float}> = [];
    public var parts:Array<ActorPart> = [];
    public function new(x:Float, y:Float) {
        super(x, y);
    }

	public function addPart(x:Float, y:Float, name:String, imageFile:String, frameWidth:Int, frameHeight:Int):ActorPart {
		var part = new ActorPart(x, y, {
            name: name,
            imageFile: imageFile,
            offsetX: x,
            offsetY: y,
            animationOffsets: []
        });

        part.loadGraphic(imageFile, true, frameWidth, frameHeight);
        parts.push(part);
        add(part);

        return part;
    }

    public function addAnimation(name:String, frames:Array<Int>, framerate:Float, loop:Bool = true, offsetX:Float = 0, offsetY:Float = 0) {
        for (part in parts) {
            part.addAnimation(name, frames, framerate, loop);
            animationOffsets.set(name, {x: offsetX, y: offsetY});
        }
    }

    public function playAnimation(name:String, forced:Bool = false) {
        for (part in parts) {
            part.playAnimation(name, forced);
            if (animationOffsets.exists(name)) {
                var offset = animationOffsets[name];
                part.x = part.data.offsetX + offset.x;
                part.y = part.data.offsetY + offset.y;
            }
        }
    }

    public static function load(name:String, ?x:Float = 0, ?y:Float = 0):Actor {
        final data:ActorJsonData = TJSON.parse(File.getContent(Paths.json('actors/' + name)));
		final directory = 'actors/${data.directory ?? name}';

        var actor = new Actor(x, y);
        for (partData in data.parts) {
            var part = actor.addPart(
                partData.offsetX, partData.offsetY, 
                partData.name, Paths.image('$directory/${partData.imageFile}'),
                partData.frameWidth, partData.frameHeight
            );

            for (animData in partData.animations) {
                part.addAnimation(
                    animData.name, 
                    animData.frames, 
                    animData.framerate, 
                    animData.loop, animData.offsetX, animData.offsetY
                );
            }
        }
        return actor;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        for (part in parts) {
            part.x = x + (part.data.offsetX * scale.x);
            part.y = y + (part.data.offsetY * scale.y);
        }
    }
}

class ActorPart extends FlxSprite {
    public var data:PartData;
    public var animationOffsets:Map<String, {x:Float, y:Float}> = [];
    public function new(x:Float, y:Float, data:PartData) {
        super(x, y, data.imageFile);
        this.data = data;
    }

    public function addAnimation(name:String, frames:Array<Int>, framerate:Float, loop:Bool = true, offsetX:Float = 0, offsetY:Float = 0) {
        animation.add(name, frames, framerate, loop);
        animationOffsets.set(name, {x: offsetX, y: offsetY});
    }

    public function playAnimation(name:String, forced:Bool = false) {
        animation.play(name, forced);
        if (animationOffsets.exists(name)) {
            var offset = animationOffsets[name];
            this.offset.x = offset.x;
            this.offset.y = offset.y;
        }
    }
}

typedef AnimationJsonData = {
    var name:String;
    var frames:Array<Int>;
    var framerate:Float;
    @:optional var loop:Bool;
    @:optional var offsetX:Float;
    @:optional var offsetY:Float;
}

typedef PartJsonData = {
    var name:String;
    var imageFile:String;
    var offsetX:Float;
    var offsetY:Float;
    var frameWidth:Int;
    var frameHeight:Int;
    var animations:Array<AnimationJsonData>;
	@:optional var layer:Int;
}

typedef ActorJsonData = {
    var name:String;
    var directory:String;
    var parts:Array<PartJsonData>;
}