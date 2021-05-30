extends KinematicBody2D_Platformer

var state_options = []

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
    #if event is InputEventKey and event.scancode == KEY_SPACE:
        pass

    if event is InputEventKey and event.scancode == KEY_K:
        pass

func animation_state():
    match $anim.current_animation:
        "idle":
            state_options = ["run", "jump"]
        "jump":
            state_options = ["idle", "run"]
        "run":
            state_options = ["idle", "jump"]
        "fall":
            state_options = ["idle"]

func jumping(delta):
    
    if Input.is_action_pressed("jump"):
        if state_options.has("jump") and y_ray_collision:
            $anim.play("jump")
            velocity.y += -JUMP

    if velocity.y > 0 and y_ray_collision == false:
        $anim.play("fall")

    if Input.is_action_just_released("jump"):
        if $anim.current_animation != "fall":
            velocity.y = velocity.y * DAMP

    if is_on_ceiling():
        velocity.y = velocity.y * DAMP

    pass

func movement(var delta):

    if Input.is_action_pressed("left"):
        direction = -1
        speed += ACCELERATION
        if is_on_floor():
            $anim.play("run")
    elif Input.is_action_pressed("right"):
        direction = 1
        speed += ACCELERATION
        if is_on_floor():
            $anim.play("run")

    else:
        if is_on_floor():
            $anim.play("idle")
            speed = lerp(speed, 0, FRICTION)
        else:
            speed = lerp(speed, 0, DAMP)


func _ready() -> void:
    $anim.play("idle")
    pass

func _physics_process(delta: float) -> void:
    #print('Parents/PlatformerControls.gd: ', $anim.current_animation)
    #print('Parents/PlatformerControls.gd: ', y_ray_collision)

    speed = clamp(speed, 0, MAX_SPEED)
    velocity.x = (speed * direction) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)

    animation_state()
    movement(delta)
    jumping(delta)
    update()
    
func _draw() -> void:
    pass
