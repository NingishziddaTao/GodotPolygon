extends Polygon2D
var velocity:Vector2

func _physics_process(delta: float) -> void:
    rotation += 0.90 * delta
    velocity = transform.x * 299
#    velocity = ($pos.position - position).normalized() * 100
    position += velocity * delta
