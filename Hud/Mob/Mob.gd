extends KinematicBody2D_Platformer

#var physical = preload("res://Stateffects/Physical.tres")

func _ready() -> void:
    direction = 1

func change_direction():
    if x_ray_collision:
        direction *= -1

func _physics_process(delta: float) -> void:
    if y_array.size() < check:
#        print('Parents/mob.gd: ', check)
        direction *= -1

    update()
    velocity.x = (direction * ACCELERATION) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)
    change_direction()

func _on_Timer_timeout() -> void:
#    position = start_position
    pass # Replace with function body.
