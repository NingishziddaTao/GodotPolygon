extends KinematicBody2D
class_name KinematicBody2D_Platformer

export(int) var ACCELERATION = 4000
export(float) var MAX_SPEED = 40000
export(float, 0, 1) var FRICTION = 0.2
export(float, 0, 1) var DAMP = 0.1
export(float) var GRAVITY = 2000
export(float) var JUMP = 800

export(Vector2) var y_ray_cast_to = Vector2(0, 30)

export(int) var x_ray_length = 80
var x_ray_cast_to = Vector2(x_ray_length, 0)
export(int) var yOffset = -5
export(int) var xOffset = -10
export(int) var yWidth = 30  
export(int) var xWidth = 30 
export(int) var steps = 5

onready var start_position = position
onready var y_ray_collision
onready var x_ray_collision

var velocity:Vector2
var speed:float
var direction:int
onready var space_state = get_world_2d().direct_space_state

func check_direction():
    if direction == 1:
        x_ray_cast_to = Vector2(x_ray_length, 0)
    if direction == -1:
        x_ray_cast_to = Vector2(-x_ray_length, 0)


func _draw() -> void:
    #print('Parents/PlatformerControls.gd: ', axis)
    check_direction()

    var y = []
    for i in range(-yWidth, yWidth, steps):
        var y_ray_position = Vector2(i, yOffset)
        var result = space_state.intersect_ray(global_position+y_ray_position,
                                               y_ray_position+global_position+y_ray_cast_to, [self])
        if result:
            y.append(result)
            draw_line(y_ray_position, result.position - position.rotated(-rotation), Color(1, 4, 1, 1))
            y_ray_collision = true
                        
        elif y == []:
            y_ray_collision = false

    var x = []
    for i in range(-xWidth, xWidth, steps):
        var x_ray_position = Vector2(xOffset, i+-20)
        var result = space_state.intersect_ray(global_position+x_ray_position,
                                               x_ray_position+global_position+x_ray_cast_to, [self])
        if result:
            x.append(result)
            draw_line(x_ray_position, result.position - position.rotated(-rotation), Color(1, 4, 1, 1))
            x_ray_collision = true
                        
        elif x == []:
            x_ray_collision = false
            
    pass


