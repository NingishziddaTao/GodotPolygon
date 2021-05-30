extends Node
class_name physical

var afflicted
#var burned = AnimationPlayer.new()
var burned = Timer.new()
var kb = null setget knocked_back

func knocked_back(set):
    pass

export(bool) var can_die = true

func take_damage(body, dmg:int, arg2 = null):
    #print('Stateffects/Physical.gd: ')
    body.hp -= dmg
    if body.hp < 1 and can_die:
        #body.queue_free()
        #yield(get_parent().queue_free(), "completed")
        body.call_deferred("queue_free")
        #Hud.emit_signal("body_died")

func freeze(body, arg1 = null, arg2 = null):
    afflicted = true
    body.modulate = Color(1, 1, 5, 1)
    $freeze.play("self")
    body.acceleration = 1000
    #body.acceleration = body.acceleration * 0.4
    yield($freeze, "animation_finished")
    body.modulate = Color(1, 1, 1, 1)
    afflicted = null
    body.acceleration = body.ACCELERATION

func burn(body, arg1 = null, arg2 = null):
    $burn.play("self")
    body.modulate = Color(4, 1, 1, 1)
    yield($burn, "animation_finished")
    body.modulate = Color(1, 1, 1, 1)

    pass

func knock_back(body, axis, kb=200):
    knocked_back(true)
    $knockback.play("self")
    body.acceleration = 35000
    body.direction = axis
    yield($knockback, "animation_finished")
    body.stopping = true
    knocked_back(null)

func timer_time_out():
    pass
