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
        Hud.emit_signal("body_died")
        #body.call_deferred("queue_free")
        body.queue_free()

func freeze(body, arg1 = null, arg2 = null):
    afflicted = true
    body.modulate = Color(1, 1, 5, 1)
    $freeze.play("self")
    body.acceleration = body.acceleration * 0.4
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

#    burned.play("b")
#    yield(burned, "animation_finished")
#    #yield(body.get_node(burned), "animation_finished")


#    body.get_node("phys").play("burn")
#    t = Timer.new();add_child(t)
#    t.wait_time = 3;t.start()
#    t.one_shot = true
#    t.connect("timeout", self, "time_out")
#func time_out():
#    print('Mob/Mob.gd: ')

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
