extends Position2D

var punching
var punch_cooldown
var punch_damage:int

var damage:int
export(NodePath) var _user

func overlapped_body(body):#signal < punch
    var axis = get_parent().scale.x
    var StatEffects = body.find_node("StatEffects")
    if StatEffects:
        StatEffects.take_damage(body, 1)
        StatEffects.knock_back(body, axis)
        StatEffects.freeze(body)
        StatEffects.burn(body)

func trow_punch(dmg=1, r=20, t=0.1):
    if !punch_cooldown:
        punch_cooldown = true
        for i in range(5):
            if !punching:
                punching = true; punch_cooldown = true
                var punch = load("res://Arms/punch/punch.tscn").instance()
                punch.get_node("circle").shape.radius = r
                punch_damage = dmg
                punch.position = Vector2.ZERO
                add_child(punch)
                yield(get_tree().create_timer(t), "timeout")
                punch.queue_free()
                yield(get_tree().create_timer(t), "timeout")
                punching = null
        yield(get_tree().create_timer(2), "timeout")
        punch_cooldown = false

func combo():
    pass

func _physics_process(delta: float) -> void:
    trow_punch(1)#auto punch
    
