extends CanvasLayer

onready var Scene = get_tree().current_scene
onready var Monitor = preload("res://Hud/decouple/Monitor.tres")
onready var monitor_start_position = $Monitor.rect_position

func monitor_slide(e:Vector2):#tween back and forth
    var s = $Monitor.rect_position
    var t = Tween.new(); Scene.add_child(t)
    if s == monitor_start_position:
        t.interpolate_property($Monitor, "rect_position", s, e, 2, Tween.TRANS_ELASTIC)
        t.start()
        yield(t, "tween_completed")
        $Monitor.visible = false
        pass
    else:
        e = monitor_start_position
        $Monitor.visible = true
        t.interpolate_property($Monitor, "rect_position", s, e, 2, Tween.TRANS_ELASTIC)
        t.start()

func check_monitor_objects():
    var monitor_object1 = Scene.find_node("Mob")
    if monitor_object1:
        Monitor.label[0].text = str(monitor_object1.speed)
    var monitor_object2 = true
    if monitor_object2:
        Monitor.label[1].text = str(Engine.get_frames_per_second())

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_Q:
        get_tree().quit()
    if event is InputEventKey and event.scancode == KEY_M:
        if event.pressed:
            monitor_slide(Vector2(-200, 0))

func _process(delta: float) -> void:  
    check_monitor_objects()  
    pass
