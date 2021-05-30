extends KinematicBody2D

export var MOVE:float = 4000
var move = MOVE
export(float) var MAX_SPEED = 40000
export(float, 0, 1) var FRICTION = 0.2
export(float, 0, 1) var DAMP = 0.1
export(float) var GRAVITY = 2000
export(float) var JUMP = 800
export var ray_offset = 20
export var ray_length = 40

var velocity:Vector2
var speed:float
var direction:int

onready var circle_radius = $circle.shape.radius
onready var start_position = position

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_SPACE:
        pass

    if event is InputEventKey and event.scancode == KEY_K:
        pass

func jumping(delta):

    if Input.is_action_pressed("jump"):
        if is_on_floor():
            velocity.y += -JUMP

    if Input.is_action_just_released("jump"):
        velocity.y = velocity.y * DAMP
    if is_on_ceiling():
        velocity.y = velocity.y * DAMP

    pass

func movement(var delta):
    speed = clamp(speed, 0, MAX_SPEED)
    velocity.x = (speed * direction) * delta
    velocity.y += GRAVITY * delta


    if Input.is_action_pressed("ui_left"):
        direction = -1
        speed += move
    elif Input.is_action_pressed("ui_right"):
        direction = 1
        speed += move

    else:
        if is_on_floor():
            speed = lerp(speed, 0, FRICTION)
        else:
            speed = lerp(speed, 0, DAMP)

        #speed = 0
            #velocity.x = lerp(velocity.x, 0, FRICTION)

 

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    movement(delta)
    jumping(delta)
    update()
    #rays()
    velocity = move_and_slide(velocity, Vector2.UP)

func rays():
    pass

func _draw() -> void:
    var space_state = get_world_2d().direct_space_state
    var width = 500
    for i in range(-width, width, width / 5):
        var xOffset = Vector2(i, 5)

        var result = space_state.intersect_ray(global_position+xOffset, xOffset+global_position+Vector2(0, ray_length), [self])
    #var result = space_state.intersect_ray(Vector2(ray_offset, 0), Vector2(ray_offset, ray_length), [self])
        if result:
    #draw_line(Vector2(ray_offset, 0), Vector2(ray_offset, ray_length), Color(1, 4, 1, 1))
    #draw_line(Vector2(-ray_offset, 0), Vector2(-ray_offset, ray_length), Color(1, 4, 1, 1))
            print(result.position)
            draw_line(xOffset, result.position - position.rotated(-rotation), Color(1, 4, 1, 1))
    pass
   
