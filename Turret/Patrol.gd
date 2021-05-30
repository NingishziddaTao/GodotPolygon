
extends Polygon2D


var velocity:Vector2
var speed:float = 20

func turn():
    speed *= -1
    
func _physics_process(delta: float) -> void:
    velocity.y = speed
    position += velocity * delta
    




func _on_Timer_timeout() -> void:
    turn()
    pass # Replace with function body.
