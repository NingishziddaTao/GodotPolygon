extends Position2D

export(Resource) var mob
#var mob = preload("res://Mob/Mob.tscn")
onready var scene = get_tree().current_scene
var a = 1

func spawn_mob():
    var m = mob.instance()
    m.position = global_position
    scene.add_child(m)

func _ready() -> void:
    pass


func _on_spawn_timeout() -> void:
    spawn_mob()
    a += 1
    print('Spawner/Spawner.gd: ', a)
    pass # Replace with function body.
