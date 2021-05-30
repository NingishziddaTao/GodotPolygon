extends KinematicBody2D_Platformer

var state_options = []
var Arms = null

signal action1
signal action2
signal action3
signal action4

var resource_timer = preload("res://ResourceTimer/ResourceTimer.tres")
var Monitor = preload("res://Hud/decouple/Monitor.tres")
var monitor:Array

func _ready() -> void:
    $anim.play("idle")
    pass

func _physics_process(delta: float) -> void:
    monitor = [y_result]
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

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("action1"):
        emit_signal("action1")

    if event.is_action_pressed("action2"):
        emit_signal("action2")

    if event.is_action_pressed("action3"):
        if Arms:
            Arms.action1 = true
        emit_signal("action3")
        #yield(resource_timer.timer(self), "completed")
        resource_timer.timer(self)
    if event.is_action_pressed("action4"):
        emit_signal("action4")

        pass
    if event is InputEventKey and event.scancode == KEY_K:
        pass

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
        $axis.scale.x = -1
        speed += ACCELERATION
        if is_on_floor():
            $anim.play("run")

    elif Input.is_action_pressed("right"):
        direction = 1
        $axis.scale.x = 1
        speed += ACCELERATION
        if is_on_floor():
            $anim.play("run")

    else:
        if is_on_floor():
            $anim.play("idle")
            speed = lerp(speed, 0, FRICTION)
        else:
            speed = lerp(speed, 0, DAMP)

func _draw() -> void:
    pass

func _on_Player_tree_entered() -> void:
    Hud.player = self

    pass # Replace with function body.
