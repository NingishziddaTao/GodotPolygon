extends Resource
class_name physical


export(bool) var can_die = true

func take_damage(body, dmg:int, arg2 = null):
    body.hp -= dmg
    if body.hp < 1 and can_die:
        body.queue_free()
