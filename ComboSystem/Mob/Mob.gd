extends KinematicBody2D_Platformer

var state_options:Array
var monitor:Array
var stopping
var anim_state:String
var Monitor = preload("res://Hud/decouple/Monitor.tres")
var physical = preload("res://Stateffects/Physical.tres")

onready var Scene = get_tree().current_scene

func _ready() -> void:
    # resource
    $anim.play("walk")
    direction = 1

func _physics_process(delta: float) -> void:
    monitor = [hp, acceleration, velocity.x, anim_state]
    update()
    friction()
    animation_state()
    walk(delta)
    velocity.y += GRAVITY * delta
    velocity.x = (direction * acceleration) * delta
    velocity = move_and_slide(velocity, Vector2.UP)

func animation_state():
    anim_state = $anim.current_animation
    match anim_state:
        "walk":
            state_options = ["walk"]
        "attack":
            state_options = ["attack2"]
        "stagger":
            state_options = []

func walk(delta):
    if state_options.has("walk") and !$StatEffects.afflicted:
        acceleration = ACCELERATION
        if x_result:
            direction *= -1
        if y_array.size() < x_ray_check:
            direction *= -1

func friction():
    if stopping:
        acceleration = lerp(acceleration, 0, FRICTION)
        if velocity.x > -1 and velocity.x < 1:
            get_node("anim").play("walk")
            stopping = false

func _on_Timer_timeout() -> void:
    pass # Replace with function body.

func _on_Mob_tree_entered() -> void:
    if !Monitor.mob:
        Monitor.mob = self

func _on_Mob_tree_exited() -> void:
    Hud.Monitor.mob = null
    pass # Replace with function body.
