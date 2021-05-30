extends Node2D

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_Q:
        get_tree().quit()
