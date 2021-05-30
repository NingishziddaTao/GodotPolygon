extends KinematicBody2D
class_name PlatformerControls

export var MOVE:float = 4000
var move = MOVE
export(float) var MAX_SPEED = 40000
export(float, 0, 1) var FRICTION = 0.2
export(float, 0, 1) var DAMP = 0.1
export(float) var GRAVITY = 2000
export(float) var JUMP = 800
export var ray_offset = 20
export var ray_length = 5

var options:Array
onready var cayote = $cayote.collision
var velocity:Vector2
var speed:float
var direction:int

onready var circle_radius = $circle.shape.radius
onready var start_position = position

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
    #if event is InputEventKey and event.scancode == KEY_SPACE:
        pass

    if event is InputEventKey and event.scancode == KEY_K:
        pass

func animation_state():
    match $anim.current_animation:
        "idle":
            options = ["run", "jump"]
        "jump":
            options = ["idle", "run"]
        "run":
            options = ["idle", "jump"]
        "fall":
            options = ["idle"]

func jumping(delta):
    

    if Input.is_action_pressed("jump"):
        if options.has("jump") and cayote:
            $anim.play("jump")
            velocity.y += -JUMP

    if velocity.y > 0 and cayote == false:
        $anim.play("fall")

    if Input.is_action_just_released("jump"):
        if $anim.current_animation != "fall":
            velocity.y = velocity.y * DAMP


    if is_on_ceiling():
        velocity.y = velocity.y * DAMP
    cayote = $cayote.collision

    pass

func movement(var delta):

    if Input.is_action_pressed("left"):
        direction = -1
        speed += move
        if is_on_floor():
            $anim.play("run")
    elif Input.is_action_pressed("right"):
        direction = 1
        speed += move
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
    print('Parents/PlatformerControls.gd: ', $anim.current_animation)
    #print('Parents/PlatformerControls.gd: ', cayote)

    speed = clamp(speed, 0, MAX_SPEED)
    velocity.x = (speed * direction) * delta
    velocity.y += GRAVITY * delta
    velocity = move_and_slide(velocity, Vector2.UP)

    animation_state()
    movement(delta)
    jumping(delta)
    update()
    #rays()

func rays():
    pass

#func _draw() -> void:
#
#    var space_state = get_world_2d().direct_space_state
#    var width = 100
#    for i in range(-width, width, width / 5):
#        var xOffset = Vector2(i, -5)
#
#        var result = space_state.intersect_ray(global_position+xOffset, xOffset+global_position+Vector2(100, ray_length), [self])
#        if result:
#            draw_line(xOffset, result.position - position.rotated(-rotation), Color(1, 4, 1, 1))
#            cayote = true
#
##    else:
##        cayote = false
#
#    pass
#
