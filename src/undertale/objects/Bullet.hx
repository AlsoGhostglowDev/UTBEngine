package undertale.objects;

class Bullet extends FlxSprite
{
    public function new(x:Float, y:Float, color:Int) {
        super(x, y);
        makeGraphic(5, 16, color);
    }
}