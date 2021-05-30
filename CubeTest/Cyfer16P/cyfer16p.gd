extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 1000 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
export var WALK_FORCE = 200
var walk_force = WALK_FORCE
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
var walk_speed = WALK_MAX_SPEED
const STOP_FORCE = 1300
var stop_force = STOP_FORCE
const JUMP_SPEED = 300
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

export (int, 0, 4000) var push = 100
export(PackedScene) var projectile

var velocity = Vector2()
var direction = Vector2()
var on_air_time = 200
var jumping = false
var stop = true

var white = Color(1, 1, 1, 1)
var can_shoot = true
var hit
var beam_duration = 2
var cooldown = 0.4
var result

var bomb = null
var prev_jump_pressed = false

enum {IDLE, USE, RUN, JUMP}

signal camera_man(cam)

#onready var LEVEL_EDITOR = preload("res://LevelEditor/LEVEL_EDITOR.tres")
#onready var SHAPES = preload("res://Resources/SHAPES.tres")
onready var start_position = get_global_position()
onready var Scene = get_tree().current_scene

onready var eyebeam = $eyebeam/line
#onready var FireArms = $FireArms
onready var rangeL = Vector2(1000, 0)


#func cast_beam():
#    var ray = $axis/FireArms/ray
#    var beam = $axis/FireArms/beam
#    ray.cast_to = Vector2(200, 0)
#    ray.add_exception(self)
#    #ray.force_raycast_update()
#    if ray.is_colliding():
#        var coll = ray.get_collision_point()
#        if beam.get_point_count() < 2:
#            beam.add_point(direction.x  * (coll - position) - Vector2(20, 0).rotated(-rotation), 1)
#        beam.set_point_position(1, direction.x * (coll - position) - Vector2(10, 0).rotated(rotation+20))
#        print('Characters/Cyfer16P/cyfer16p.gd: ', direction.x)
#    else:
#        if beam.get_point_count() < 2:
#            beam.add_point(ray.cast_to, 1)
#        beam.set_point_position(1,ray.cast_to.rotated(-rotation))
#        #beam_part.emitting = true
#        pass
#        
#        

func _ready():
# warning-ignore:return_value_discarded
#    connect("camera_man", LEVEL_EDITOR.Camera2D, "get_camera_man")
    emit_signal("camera_man", $cam)
    $axis/anim.frame = IDLE
    pass

func _unhandled_input(event):
    if event is InputEventKey and event.scancode == KEY_K:
        #if event.pressed and FireArms.can_beam == true:
            #FireArms.beam_switch(self)
        pass
           
    if Input.is_action_just_pressed("action"):
        bomb = projectile.instance()
        bomb.direction = $axis.scale.x
        bomb.global_position = $axis/gun.global_position
        get_tree().current_scene.add_child(bomb)

func _physics_process(delta):
#    SHAPES.generate_line(eyebeam)
    var space_state = Scene.get_world_2d().direct_space_state
    result = space_state.intersect_ray(global_position, global_position+Vector2(1000, 0))
    
    # Integrate forces to velocity
    var speed = walk_force * direction.x
    velocity.x = (speed * delta) / delta

    velocity.y += GRAVITY * delta
    # Integrate velocity into motion and move
    
    var jump = Input.is_action_pressed("jump")

    # This represents the player's inertia.

    # after calling move_and_slide()

    # Push
    for index in get_slide_count():
        var collision = get_slide_collision(index)
        if collision.collider.is_in_group("bodies"):
            collision.collider.apply_central_impulse(-collision.normal * push)

    if Input.is_action_pressed("move_left"):
        walk_force = WALK_FORCE
        direction.x = -1
        $axis.scale.x = -1
        if is_on_floor() and $axis/anim.frame != JUMP:
            $axis/anim.frame = RUN

    elif Input.is_action_pressed("move_right"):
        walk_force = WALK_FORCE
        direction.x = 1
        $axis.scale.x = 1
        if is_on_floor() and $axis/anim.frame != JUMP:
            $axis/anim.frame = RUN
        
    else:
        walk_force = lerp(walk_force, 0, .8)
#
##        var vsign = sign(velocity.x)
##        var vlen = abs(velocity.x)
##        vlen -= stop_force * delta
#        if vlen < 0:
#            vlen = 0
#        velocity.x = vlen * vsign

        if !jumping and stop:
            $axis/anim.frame = IDLE
    
    if is_on_floor():
        on_air_time = 0

    if global_position.y > 400:
        global_position = start_position
        
    if jumping and velocity.y > 0:
        # If falling, no longer jumping
        jumping = false
        $axis/anim.frame = RUN

    if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping or is_on_wall():
        # Jump must also be allowed to happen if the character left the floor a little bit ago.
        # Makes controls m ore snappy.
        $axis/anim.frame = JUMP
        velocity.x = direction.x * -1000
        velocity.y = -JUMP_SPEED
        jumping = true

    #if FireArms.beaming:
    #cast_beam()
    #FireArms.cast_beam(self)

#    for i in $axis.get_children():
#        if i.has_method("cast_beam"):
#            i.cast_beam(self)
#    

    on_air_time += delta
    prev_jump_pressed = jump

    
    # Veloocity floor slope floor angle ineertia
    velocity = move_and_slide(velocity, Vector2.UP, false, 4000, PI/2, false)
    update()

func _draw():
    if result:
        draw_circle(result.position, 30, white)

    pass

