extends Polygon2D

var velocity = Vector2()
const SPEED = 100

func _ready() -> void:
    pass
func start(_transform):
    global_transform = _transform
    velocity = transform.x * SPEED
       
func _physics_process(delta: float) -> void:
    rotation = velocity.angle()
    position += velocity * delta
    
    
