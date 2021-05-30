tool
extends Position2D

var result
var collision = false
export(Vector2) var cast_to = Vector2(0, 20)
#export(int) var step = 10
export(int) var yOffset = -50

func _ready() -> void:
    #print('Parents/KINEMATIC_BODY_2D/mats/cayote.gd: ' , get_world_2d())
    pass

    
func _physics_process(delta: float) -> void:
    update()

func _draw() -> void:
    var p = get_parent()
    var a = []
    var space_state = get_world_2d().direct_space_state
    var e = gizmo_extents
    for x in range(-e, e, e / 10 ):
        var xOffset = Vector2(x, yOffset)

        result = space_state.intersect_ray(global_position+xOffset, global_position+xOffset+cast_to, [self, p])
        if result:
            a.append(result)
            draw_line(xOffset, result.position - p.position.rotated(-rotation), Color(1, 4, 1, 1))
            collision = true
        if a == []:
            collision = false

    pass
   
