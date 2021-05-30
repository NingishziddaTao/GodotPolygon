extends StaticBody2D

onready var start_position = position
var velocity:Vector2
export var SPEED:float = 200
var speed = SPEED
onready var pos =$pos
#onready var pos = get_parent().get_node("pos")

func check_position():
    if global_position.distance_to(get_global_mouse_position()) < 20:
        speed = 0
    else:
        speed = SPEED
        
func _ready() -> void:
    print($poly.polygon)
    $coll.polygon = $poly.polygon
    pass
func one_point():
    if $line.get_point_count() > 1:
        $line.remove_point(1)
    if $line.get_point_count() < 2:
        $line.add_point(get_local_mouse_position())
func reset():
    
    global_position = start_position
    
func _physics_process(delta: float) -> void:
    check_position()
    pos.global_position = get_global_mouse_position()
    var p = get_global_mouse_position()
    var a = (p - position).angle()
    velocity = Vector2(speed, 0).rotated(a)
    position += velocity * delta
    one_point()
    update()
    
    pass
    
func _draw() -> void:
    draw_line(Vector2.ZERO, pos.position, Color(1, 1, 1, 1), 2)

func _on_Timer_timeout() -> void:
#    reset()
#    print(0)
    pass # Replace with function body.
