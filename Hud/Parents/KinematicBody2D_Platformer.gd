extends KinematicBody2D
class_name KinematicBody2D_Platformer

export(Array, Resource) var stat_effects
export(int) var hp = 1

export(int) var ACCELERATION = 4000
export(float) var MAX_SPEED = 40000
export(float, 0, 1) var FRICTION = 0.2
export(float, 0, 1) var DAMP = 0.1
export(float) var GRAVITY = 2000
export(float) var JUMP = 800

export(int) var x_ray_length = 80
onready var x_ray_cast_to = Vector2(x_ray_length, 0)
export(int) var y_ray_length = 30
onready var y_ray_cast_to = Vector2(0, y_ray_length)
export(int) var yOffset = -5
export(int) var xOffset = -10
export(int) var x_ray_y_offset = -20
export(int) var yWidth = 30  
export(int) var xWidth = 30
export(int) var steps = 5

var x_result 
var y_result
var y_array = []

onready var start_position = position
onready var y_ray_collision
onready var x_ray_collision

var velocity:Vector2
var speed:float
var direction:int
onready var space_state = get_world_2d().direct_space_state
var check

func _ready() -> void:
    check = (yWidth + yWidth) / steps

func resource_method(method:String, body, arg1=null, arg2=null):
    for i in stat_effects:
        if i != null:
            if i.has_method(method):
                i.call(method, body, arg1, arg2)

func check_direction():
    if direction == 1:
        x_ray_cast_to = Vector2(x_ray_length, 0)
    if direction == -1:
        x_ray_cast_to = Vector2(-x_ray_length, 0)

func _draw() -> void:
    #print('Parents/PlatformerControls.gd: ', axis)
    check_direction()

    y_array = []
    for i in range(-yWidth, yWidth, steps):
        var y_ray_position = Vector2(i, yOffset)
        y_result = space_state.intersect_ray(global_position+y_ray_position,
                                               y_ray_position+global_position+y_ray_cast_to, [self])
        if y_result:
            y_array.append(y_result)
            draw_line(y_ray_position, y_result.position - position.rotated(-rotation), Color(1, 4, 1, 1))
            y_ray_collision = true

                
        elif y_array == []:
            y_ray_collision = false

    var x = []
    for i in range(-xWidth, xWidth, steps):
        var x_ray_position = Vector2(xOffset, i+x_ray_y_offset)
        x_result = space_state.intersect_ray(global_position+x_ray_position,
                                               x_ray_position+global_position+x_ray_cast_to, [self])
        if x_result:
            x.append(x_result)
            draw_line(x_ray_position, x_result.position - position.rotated(-rotation), Color(1, 4, 1, 1))
            x_ray_collision = true
                        
        elif x == []:
            x_ray_collision = false
            
    pass


