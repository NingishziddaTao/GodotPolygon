extends Node

onready var Scene = get_tree().current_scene

onready var player = Scene.find_node("Player")

var monitor_array = [player.velocity]

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_Q:
        get_tree().quit()
