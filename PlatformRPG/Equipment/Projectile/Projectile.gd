extends Area2D

export(bool) var knock_back
export(bool) var freeze
export(bool) var burn
var axis = null

var speed = 1000
var velocity = Vector2()

func start(pos, dir):
    position = pos
    rotation = dir
    velocity = Vector2(speed, 0).rotated(dir)

func _ready() -> void:
    pass

func _physics_process(delta):
    position += velocity * delta

func _on_Bullet_body_entered(body):
    var StatEffects = body.find_node("StatEffects")
    queue_free()
    if StatEffects:
        StatEffects.take_damage(body, 1)
        if freeze:
            StatEffects.freeze(body)
        if knock_back and axis:
            StatEffects.knock_back(body, axis)
        if burn:
            StatEffects.burn(body)

func _on_desolve_timeout() -> void:
    queue_free()
    pass # Replace with function body.
