package undertale.states.debug;

import undertale.objects.Actor.ActorPart;

@:access(undertale.objects.Actor)
class ActorEditorState extends BaseState {
    public var actor:Actor;

    override function create() {
        super.create();

        actor = new Actor(0, 0);
		actor.addPart(8, 23, 'legs', Paths.image('actors/sans/legs'), 42, 41);
        final torso = actor.addPart(0, 0, 'torso', Paths.image('actors/sans/torso'), 63, 30);
		torso.addAnimation('idle', [1], 0, true);
        torso.playAnimation('idle');
        final head = actor.addPart(17, -23, 'head', Paths.image('actors/sans/head'), 29, 30);
		head.addAnimation('idle', [0], 0, true);

        add(actor);
        actor.screenCenter();

        FlxG.camera.zoom = 5;
    }

    var selectedPart:ActorPart;
    override function update(elapsed:Float) {
        super.update(elapsed);

        for (part in actor.parts) {
            part.color = 0xFFFFFFFF;
            if (FlxG.keys.justPressed.Z && FlxG.mouse.overlaps(part)) {
                selectedPart = part;
                break;
            }
        }
        if (selectedPart != null) selectedPart.color = 0xFFAAFFAA;

        if (FlxG.mouse.pressed && selectedPart != null) {
            selectedPart.data.offsetX += FlxG.mouse.deltaScreenX;
            selectedPart.data.offsetY += FlxG.mouse.deltaScreenY;
        }

        if (FlxG.keys.justPressed.X) {
            selectedPart = null;
        }

        if (FlxG.keys.justPressed.C) {
            for (part in actor.parts) {
                trace([
                    '--------------------------------',
                    'Part: ' + part?.data?.name ?? 'Unnamed Part',
                    'Image File: ' + part?.data?.imageFile ?? 'N/A',
                    'Offset (X: ' + part.data.offsetX + ', Y: ' + part.data.offsetY + ')',
                    'Current Position (X: ' + part.x + ', Y: ' + part.y + ')'
                ].join('\n'));
            }
        }
    }
}