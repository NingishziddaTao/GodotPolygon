extends Polygon2D

export(int, 2, 20) var bullet_quantity = 2
export(float, 0.1, 3.6) var bullet_spread = 0.1
export(PackedScene) var bullet

""" needs atleast 2 bulletullets """

func _ready() -> void:
    pass
    
func spread_shot():
    for i in range(bullet_quantity):
        var b = bullet.instance()
        var a = -bullet_spread + i * (2*bullet_spread)/(bullet_quantity-1)
        b.start($pos.global_position, transform)
        b.rotation = transform.x.angle() + a
        get_parent().add_child(b)
    pass

func _on_Timer_timeout() -> void:
    spread_shot()
    pass # Replace with function bulletody.

#func _physics_process(delta: float) -> void:
##    rotation += 3 * delta
#    pass
