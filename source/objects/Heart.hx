package objects;

enum HeartType {
    DETERMINATION;  // RED
    INTEGRITY;      // BLUE
    JUSTICE;        // YELLOW
    PERSEVERANCE;   // PURPLE
    KINDNESS;       // GREEN
    BRAVERY;        // ORANGE
    PATIENCE;       // AQUA
}

class Heart extends FlxSprite {
    public var canMove:Bool = true;
    public var heartType:HeartType = DETERMINATION;

    static var controls = Controls.instance;

    // attributes
    public static var MOVEMENT_SPEED = 4;
    public static var MOVEMENT_SPEED_SLOWED = 2;
    public static var JUMP_VELOCITY = 10;
    public static var GRAVITY = 10; 
	public static var GRAVITY_MULT = 1;

    public function new(x, y) {
        super(x, y, Paths.image('heart'));
        scale.set(0.05, 0.05);
        updateHitbox();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (canMove) {
			final speed:Float = controls.GAME_SLOW ? MOVEMENT_SPEED_SLOWED : MOVEMENT_SPEED;
            switch (heartType) {
                case INTEGRITY:
                    if (controls.GAME_LEFT)  x -= speed;
                    if (controls.GAME_RIGHT) x += speed;
                    if (controls.GAME_UP)    velocity.y -= JUMP_VELOCITY * GRAVITY_MULT;
                case BRAVERY:
                    if (controls.GAME_LEFT)  velocity.x = -speed;
                    if (controls.GAME_DOWN)  velocity.y =  speed;
                    if (controls.GAME_UP)    velocity.y = -speed;
                    if (controls.GAME_RIGHT) velocity.x =  speed;
                default:
                    if (controls.GAME_LEFT)  x -= speed;
                    if (controls.GAME_DOWN)  y += speed;
                    if (controls.GAME_UP)    y -= speed;
                    if (controls.GAME_RIGHT) x += speed;
            }
        }
    } 
}