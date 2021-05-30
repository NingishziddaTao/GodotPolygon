extends KinematicBody2D_Platformer
func _ready() -> void:
    direction = 1

func change_direction():
    if x_ray_collision:
        direction *= -1

func _physics_process(delta: float) -> void:
    if y_array.size() < y_ray_amound:
        print('Parents/mob.gd: ', y_ray_amound)
        direction *= -1

    set_y_array(y_array)
    update()
    velocity.x = (direction * ACCELERATION) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)
    change_direction()

func _on_Timer_timeout() -> void:
    position = start_position
    pass # Replace with function body.
