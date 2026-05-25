package undertale.objects;

import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

enum HeartType {
	DETERMINATION; // RED
	INTEGRITY; // BLUE
	JUSTICE; // YELLOW
	PERSEVERANCE; // PURPLE
	KINDNESS; // GREEN
	BRAVERY; // ORANGE
	PATIENCE; // AQUA
}

class Heart extends FlxSpriteGroup {
	public var canMove:Bool = true;
	public var canJump:Bool = true;
	public var flappyBird:Bool = false;
	public var heartType:HeartType = DETERMINATION;

	static var controls = Controls.instance;

	// attributes
	public static var MOVEMENT_SPEED = 3;
	public static var MOVEMENT_SPEED_SLOWED = 1.5;
	public static var JUMP_VELOCITY = 150;
	public static var GRAVITY = 10;
	public static var GRAVITY_MULT = 1;

	public var braveryVelocity:FlxPoint = FlxPoint.weak(0, 0);
	public var patienceOffset:FlxPoint = FlxPoint.weak(0, 0);

	public var sprite:FlxSprite;
	public var hitbox:FlxObject;

	public function new(x, y)
	{
		super(x, y);
		sprite = new FlxSprite();
		sprite.loadGraphic(Paths.image('heart'));
		sprite.setGraphicSize(16);
		sprite.updateHitbox();
		add(sprite);

		hitbox = new FlxSprite(0, 0).makeGraphic(16, 16, 0xFFFF0000);
		hitbox.active = false;

		changeType(heartType);
	}

	var jumpElapsed:Float = 0;
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (canMove)
		{
			var speed:Float = controls.GAME_SLOW ? MOVEMENT_SPEED_SLOWED : MOVEMENT_SPEED;
			switch (heartType)
			{
				case INTEGRITY:
					if (controls.GAME_LEFT) x -= speed;
					if (controls.GAME_RIGHT) x += speed;
					if (flappyBird) {
						if (controls.GAME_UP_P) velocity.y = JUMP_VELOCITY * -GRAVITY_MULT;
					} else {
						if (controls.GAME_UP && canJump) {
							velocity.y = JUMP_VELOCITY * -GRAVITY_MULT;
							jumpElapsed += elapsed;
							if (jumpElapsed > 0.25)
								canJump = false;
						}
					}
					if (controls.GAME_UP_R && canJump) canJump = false;
					acceleration.y = GRAVITY * GRAVITY_MULT * 50;
				case BRAVERY:
					if (controls.GAME_LEFT) 	  { braveryVelocity.x = -1; braveryVelocity.y = 0; }
					else if (controls.GAME_DOWN)  { braveryVelocity.x = 0; braveryVelocity.y = 1;  }
					else if (controls.GAME_UP) 	  { braveryVelocity.x = 0; braveryVelocity.y = -1; }
					else if (controls.GAME_RIGHT) { braveryVelocity.x = 1; braveryVelocity.y = 0;  }
				case PATIENCE:
					if (controls.GAME_LEFT) 	  patienceOffset.x -= speed;
					else if (controls.GAME_DOWN)  patienceOffset.y += speed;
					else if (controls.GAME_UP) 	  patienceOffset.y -= speed;
					else if (controls.GAME_RIGHT) patienceOffset.x += speed;

					if ((controls.GAME_LEFT_R || controls.GAME_RIGHT_R || controls.GAME_UP_R || controls.GAME_DOWN_R)
						&& !(controls.GAME_LEFT && controls.GAME_RIGHT && controls.GAME_UP && controls.GAME_DOWN)) {
						x += patienceOffset.x;
						y += patienceOffset.y;
						patienceOffset.set(0, 0);
					}
				default:
					if (controls.GAME_LEFT) x -= speed;
					if (controls.GAME_DOWN) y += speed;
					if (controls.GAME_UP) y -= speed;
					if (controls.GAME_RIGHT) x += speed;
			}
		}

		if (heartType == BRAVERY) {
			velocity.x = braveryVelocity.x * (controls.GAME_SLOW ? MOVEMENT_SPEED_SLOWED : MOVEMENT_SPEED) * 50;
			velocity.y = braveryVelocity.y * (controls.GAME_SLOW ? MOVEMENT_SPEED_SLOWED : MOVEMENT_SPEED) * 50;
		}

		sprite.flipY = heartType == JUSTICE;
	}

	public function changeType(type:HeartType) {
		heartType = type;
		switch (type) {
			case DETERMINATION: sprite.color = 0xFFFF0000;
			case INTEGRITY: sprite.color = 0xFF0000FF;
			case JUSTICE: sprite.color = 0xFFFFFF00;
			case PERSEVERANCE: sprite.color = 0xFFD300FF;
			case KINDNESS: sprite.color = 0xFF00FF00;
			case BRAVERY: sprite.color = 0xFFFFA500;
			case PATIENCE: sprite.color = 0xFF00FFFF;
		}

		braveryVelocity.set(0, 0);
		velocity.set(0, 0);
		acceleration.set(0, 0);
	}
}
