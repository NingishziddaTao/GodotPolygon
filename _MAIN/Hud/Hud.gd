extends CanvasLayer

onready var Scene = get_tree().current_scene
onready var Monitor = preload("res://Hud/decouple/Monitor.tres")
onready var monitor_start_position = $Monitor.rect_position

var mob_array:Array

var tweening
var monitor_number = 0
signal body_died

func _ready() -> void:
    pass

func monitor_slide(e:Vector2):#tween back and forth
    if !tweening:
        tweening = true
        var s = $Monitor.rect_position
        var t = Tween.new(); Scene.add_child(t)
        if s == monitor_start_position:
            t.interpolate_property($Monitor, "rect_position", s, e, 2, Tween.TRANS_ELASTIC)
            t.start()
            yield(t, "tween_completed")
            tweening = false
            $Monitor.visible = false
            pass
        else:
            e = monitor_start_position
            $Monitor.visible = true
            t.interpolate_property($Monitor, "rect_position", s, e, 2, Tween.TRANS_ELASTIC)
            t.start()
            yield(t, "tween_completed")
            tweening = false

func check_monitor_objects():
    var object = Monitor.Arms
    if object:
        var object_array = object.monitor
        for i in object_array:
            Monitor.label[monitor_number].text = str(i)
            if monitor_number < object_array.size()-1:
                monitor_number += 1
            else:
                monitor_number = 0

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_Q:
        get_tree().quit()
    if event is InputEventKey and event.scancode == KEY_M:
        if event.pressed:
            monitor_slide(Vector2(-200, 0))

func _physics_process(_delta):
    check_monitor_objects()  
    pass
