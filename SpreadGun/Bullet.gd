extends Polygon2D

var velocity:Vector2
export(float) var SPEED

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    velocity = transform.x * SPEED
    position += velocity * delta
    
func start(_start_pos, _transform):
    rotation = _transform.x.angle()
    global_position = _start_pos
#    get_tree().current_scene.add_child(self.instance())

func _on_VisibilityNotifier2D_screen_exited() -> void:
    queue_free()
    pass # Replace with function body.
