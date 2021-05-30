extends KinematicBody2D

export(int) var FRICTION = 0.4
export(int) var speed = 30000
export(int) var GRAVITY = 300
onready var gravity = GRAVITY
export(float, 1, 15) var rotation_speed = 5
var velocity:Vector2

func _ready() -> void:
    pass
    
func check_bounce(delta):
    if !$cayote.collision:
        gravity = 0
        var collider = move_and_collide(velocity * delta)
        if collider:
            velocity = velocity.bounce(collider.normal)
    elif $cayote.collision:
        gravity = GRAVITY
        print('Ball-k/Ball-k.gd: ', gravity)
        #velocity.y = gravity * delta
        #velocity.y += gravity * delta
        velocity = velocity * 0.93
        velocity = move_and_slide(velocity, Vector2.UP)

#for i in get_slide_count():
#    velocity = (velocity.bounce(get_slide_collision(i).normal) * speed) * delta

func dash(delta):
    if Input.is_action_just_pressed("jump"):
        velocity = transform.x * speed * delta
        $cayote.cast_to = Vector2.ZERO
        yield(get_tree().create_timer(0.2), "timeout")
        $cayote.cast_to = Vector2(0, 55)

func _physics_process(delta: float) -> void:
    $cayote.global_rotation -= rotation_speed * delta
    rotation += rotation_speed  * delta
    check_bounce(delta)
    dash(delta)
    
    pass
    
func _draw() -> void:
    pass
