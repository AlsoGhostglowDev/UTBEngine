package undertale.backend;

class BaseState extends FlxState {
    public var controls:Controls;
    public function new() {
        super();
        controls = Controls.instance;
    }
}