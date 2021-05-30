extends KinematicBody2D_Platformer

var state_options:Array
var anim_state:String

var stopping

var Monitor = preload("res://Hud/decouple/Monitor.tres")
var monitor:Array

onready var Scene = get_tree().current_scene

func _ready() -> void:
    $anim.play("walk")
    direction = 1

func _physics_process(delta: float) -> void:
    monitor = [hp, acceleration, is_on_floor(), anim_state]
    update()
    jump()
    friction()
    animation_state()
    walk(delta)
    velocity.x = (direction * acceleration) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)

func animation_state():
    anim_state = $anim.current_animation
    match anim_state:
        "walk":
            state_options = ["walk"]
            pass
        "attack":
            state_options = ["attack2"]
            pass
        "jump":
            state_options = ["walk", "fall"]

func walk(delta):
    if state_options.has("walk") and !$StatEffects.afflicted:
        if is_on_floor():
            $anim.play("walk")
            acceleration = ACCELERATION
            if x_result and x_result != {}:
                direction *= -1
            if y_array.size() < x_ray_check:
                direction *= -1

func jump():
    if !is_on_floor():
        acceleration = 50000
        $anim.play("jump")

func friction():
    if stopping:
        acceleration = lerp(acceleration, 0, FRICTION)
        if velocity.x > -1 and velocity.x < 1:
            if is_on_floor():
                get_node("anim").play("walk")
                stopping = false

func _on_Timer_timeout() -> void:
    velocity = Vector2(90000, -JUMP)
    pass # Replace with function body.

func _on_Jumper_tree_entered() -> void:
    Hud.jumper = self
    pass # Replace with function body.

func _on_Jumper_tree_exiting() -> void:
    Hud.jumper = null
    pass # Replace with function body.
