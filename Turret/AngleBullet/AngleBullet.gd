extends Area2D

export var  speed:float = 0.4
export var steer_strength:float = 0.10
export var MAX_SPEED = 500
var velocity = Vector2()
var target_velocity = Vector2()
var target = null


onready var shape_radius = $CollisionShape2D.get_shape().radius

func seek():
    var steer:Vector2
    if target:
        var target_direction = (target.position - position).normalized() * speed
        print((target.position - position).normalized())
        steer = (target_direction -  velocity).normalized() * steer_strength
        return steer
#    else:
#        velocity 

func seek_copy():
    var steer = Vector2.ZERO
    if target:
        var desired = (target.position - position).normalized() * speed
        steer = (desired - velocity).normalized() * steer_strength
    return steer        

func _physics_process(delta: float) -> void:

    target_velocity = seek_copy()
    velocity += target_velocity * delta
    velocity = velocity.clamped(MAX_SPEED)
    rotation = velocity.angle()
#    velocity += target_velocity * delta
#    print(velocity)
    position += velocity * delta
    
func start(start_pos, angle, _target=null):
    target = _target
    position = start_pos
    rotation = angle
    velocity = Vector2(speed, 0).rotated(angle)
    
func _draw():
    draw_circle(get_parent().global_position, shape_radius, Color(1, 1, 1, 1))

func _on_destroy_timeout() -> void:
    queue_free()
    pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited() -> void:
    queue_free()
    pass # Replace with function body.
