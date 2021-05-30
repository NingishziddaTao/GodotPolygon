extends StaticBody2D
onready var Scene = get_tree().current_scene
export var turn_speed: float = 10
func shoot(_pos):
    var b = load("res://AngleBullet/AngleBullet.tscn").instance()
    var a = (_pos - global_position).angle()
    b.start($pos.global_position, a, Scene.get_node("Patrol"))
    Scene.add_child(b)

func _physics_process(delta: float) -> void:
    rotation += turn_speed * delta
    pass
   
func _on_Timer_timeout() -> void:
    shoot($pos.global_position)
#    scale.x *= -1
    pass # Replace with function body.
