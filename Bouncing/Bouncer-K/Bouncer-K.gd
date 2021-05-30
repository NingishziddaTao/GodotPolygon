extends KinematicBody2D

onready var start_position = position
var velocity:Vector2
export var SPEED:float = 200
onready var speed = SPEED


func _ready() -> void:
    velocity = Vector2(speed, 100)
    pass

func _physics_process(delta: float) -> void:
    var collider = move_and_collide(velocity * delta)

    if collider:
        velocity = velocity.bounce(collider.normal)
    
func _draw() -> void:
    pass
