extends KinematicBody2D

onready var start_position = position
var velocity:Vector2
export var SPEED:float = 200
var speed = SPEED
onready var circle_radius = $circle.shape.radius

func _ready() -> void:
    pass

func _physics_process(delta: float) -> void:
    pass
    
func _draw() -> void:
    pass
