extends Polygon2D


func _ready() -> void:
    pass
func _physics_process(delta: float) -> void:
    rotation += 4 * delta

func shoot():
    var b = load("res://TransformBullet/TransformBullet.tscn").instance()
    b.start($pos.global_transform)
    get_parent().add_child(b)
    
func _on_Timer_timeout() -> void:
    scale.x *= -1
    shoot()
    
    pass # Replace with function body.
