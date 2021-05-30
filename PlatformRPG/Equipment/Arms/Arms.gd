extends Position2D

var punching
var punch_cooldown
var punch_damage:int
var combo_options = ["punch1"]
var animating
#var start_time:float
var combo_state

var Monitor = preload("res://Hud/decouple/Monitor.tres")
var monitor:Array
var nr = 0

var damage:int
export(NodePath) var _user
var user = null

func _ready() -> void:
    connect_user()
    pass

func _physics_process(delta: float) -> void:
    monitor = [nr, combo_state, animating]
    punch_state()
    return_idle()
    pass
            
func punch_state():
    combo_state = $combo.current_animation
    match combo_state:

        "idle":
            combo_options = ["punch1"]
            if animating:
                $combo.play("punch1")
                animating = null

        "punch1":
            combo_options = ["idle", "punch2"]
            if animating:
                yield(get_node("combo"), "animation_finished")
                $combo.play("punch2")

        "punch2":
            if animating:
                yield(get_node("combo"), "animation_finished")
                $combo.play("punch3")

        "kick":
            pass

        "punch3":
            pass

func connect_user():
    if !_user:
        return
    else:
        user = get_node(_user)
        #user.connect("animating", self, "combo")
        user.Arms = self

func return_idle():
    if animating == null:
        yield(get_node("combo"), "animation_finished")
        $combo.play("idle")

func overlapped_body(body):#signal < punch
    var axis = get_parent().scale.x
    var StatEffects = body.find_node("StatEffects")
    if StatEffects:
        StatEffects.take_damage(body, punch_damage)
        StatEffects.knock_back(body, axis)
        StatEffects.freeze(body)
        StatEffects.burn(body)

func trow_punch(dmg=1, r=20, t=0.1):
    yield(get_tree(), "idle_frame")
    if !punching:
        punching = true
        punch_damage = dmg
        var punch = load("res://Equipment/Arms/punch/punch.tscn").instance()
        punch.get_node("circle").shape.radius = r
        punch.position = Vector2.ZERO
        add_child(punch)
        yield(get_tree().create_timer(t), "timeout")
        punch.queue_free()
        yield(get_tree().create_timer(0.2), "timeout")
        punching = false

    pass

func _on_Arms_tree_entered() -> void:
    Hud.Arms = self

#func _on_combo_animation_changed(old_name: String, new_name: String) -> void:
#    animating = null
#    pass # Replace with function body.

func _on_combo_animation_finished(anim_name: String) -> void:
    animating = null
    pass # Replace with function body.

