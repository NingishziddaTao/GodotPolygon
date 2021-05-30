extends Position2D

export(PackedScene) var mob
onready var Scene = get_tree().current_scene

func spawn_mob():
    var m = mob.instance()
    m.global_position = global_position
#    Scene.add_child(m)
    Scene.call_deferred("add_child", m)

func body_died():#signal < physical
    print('Spawner/Spawner.gd: ')
    spawn_mob()

func _ready() -> void:
    Hud.connect("body_died", self, "body_died")
    pass

func _on_spawn_timeout() -> void:
    spawn_mob()
    pass # Replace with function body.
