extends RigidBody2D

onready var start_position = position
var velocity:Vector2
export var SPEED:float = 200
var speed = SPEED
#onready var circle_radius = $circle.shape.radius

func _ready() -> void:
#    $coll.polygon = $coll/poly.polygon
    pass

func _physics_process(delta: float) -> void:
    pass
    
func _draw() -> void:
#    draw_circle($circle.position, circle_radius, Color.white)
    pass


func _on_RIGID_BODY_2D_body_entered(body: Node) -> void:
#    print("collided")
    pass # Replace with function body.
