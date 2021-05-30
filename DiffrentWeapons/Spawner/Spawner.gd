extends Position2D

export(Resource) var mob
#var mob = preload("res://Mob/Mob.tscn")
onready var Scene = get_tree().current_scene

func spawn_mob():
    var m = mob.instance()
    m.position = global_position
    #Scene.call_deferred("add_child", "m")
    yield(get_tree().create_timer(1), "timeout")
    Scene.add_child(m)

func body_died():#signal < physical
    spawn_mob()

func _ready() -> void:
    Hud.connect("body_died", self, "body_died")
#    call_deferred("spawn_mob")
    spawn_mob()
    pass


func _on_spawn_timeout() -> void:
#    spawn_mob()
    print('Spawner/Spawner.gd: ')
    pass # Replace with function body.
