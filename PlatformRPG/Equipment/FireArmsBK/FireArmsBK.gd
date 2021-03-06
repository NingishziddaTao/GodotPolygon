extends Node2D

onready var Scene = get_tree().current_scene
#onready var SceneDecouple = preload("res://Levels/SceneDecouple.tres")
onready var beam_end = $end

export(float) var shot_cooldown = 0.5

export(NodePath) var _user
onready var user = find_node(_user)
export(NodePath) var _laser
onready var laser = find_node(_laser)

export(PackedScene) var bullet

var targets:Array
var target:Object
var target_number = 0
var current_target = null
var switching = null
var switch_off = true
var delay_off = true
var white = Color(1, 1, 1, 1)

func _ready():
    line_setup()
    connect_user()

func connect_user():
    if !_user:
        return
    else:
        user = get_node(_user)
        user.FireArms = self

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.scancode == KEY_LEFT:
        if event.pressed:
            select_target("left")
    if event is InputEventKey and event.scancode == KEY_RIGHT:
        if event.pressed:
            select_target("right")
        pass

func select_target(direction:String):

    if current_target:
        current_target.modulate = Color(1, 1, 1, 1)

    if direction == "right":
        if target_number < targets.size()- 1 and targets.size() >= 0:
            target_number += 1
            current_target = targets[target_number]
            current_target.modulate = Color(1, 1, 3, 1)

        else:
            target_number = 0
            if targets.size() > 0:
                current_target = targets[target_number]
                current_target.modulate = Color(1, 1, 3, 1)

#        if current_target:
#            current_target = targets[target_number]
#            current_target.modulate = Color(1, 1, 1, 1)

    if direction == "left":
        if target_number > 0:
            target_number -= 1
            current_target = targets[target_number]
            current_target.modulate = Color(1, 1, 3, 1)

        else:
            target_number = targets.size() -1
            if targets.size() > 0:
                current_target = targets[target_number]
                current_target.modulate = Color(1, 1, 3, 1)


    pass

#######################################################################################################################

func drop_rigid(_user):
    var new_drop = user.drop.instance()
    new_drop.position = user.get_node("drop").global_position

    if user.drop_count >= 1:
        user.drop_count -= 1
        user.get_parent().add_child(new_drop)

#######################################################################################################################

# The user need a line2d called beam a position called muzzle and particles called part

export(float) var beam_duration = 1.5
export(float) var beam_cd  = 0.5

onready var can_beam = true
onready var beaming = false

onready var beam_part = $end/part
onready var beam = $beam
onready var ray = $ray
onready var line = $line
onready var muzzle = $muzzle

func line_setup():
    if line.get_point_count() > 1:
        line.remove_point(1)

func beam_switch(_user):
    user = user
    can_beam = false
    beaming = true

    yield(get_tree().create_timer(beam_duration), "timeout")
    beaming = false
    if line.get_point_count() > 1:
        line.remove_point(1)
    beam_part.emitting = false

    yield(get_tree().create_timer(beam_cd), "timeout")
    can_beam = true
    
func cast_beamT(_user):
    var space_state = get_world_2d().direct_space_state

    var result = space_state.intersect_ray(muzzle.global_position, 
                                           muzzle.global_position + muzzle.transform.x * 1000, [user])

    if result:
        if line.get_point_count() < 2:
            line.add_point(muzzle.transform.xform_inv(result.position), 1)
        line.set_point_position(1, muzzle.transform.xform_inv(result.position))
    
    else:
        if line.get_point_count() < 2:
            line.add_point(muzzle.transform.xform_inv(muzzle.global_position + muzzle.transform.x * 1000))

        line.set_point_position(1, muzzle.transform.xform_inv(muzzle.global_position + muzzle.transform.x * 1000))

func cast_line():
    var coll = ray.get_collision_point()
    if ray.is_colliding():
        if line.get_point_count() < 2:
            line.add_point(ray.transform.xform_inv(coll) - user.position * user.direction.x, 1)
        line.set_point_position(1, ray.transform.xform(coll) - user.position)
    else:
        if line.get_point_count() < 2:
            line.add_point(ray.cast_to, 1)
        line.set_point_position(1,ray.cast_to)
        beam_part.emitting = true

func cast_to():
    var axis = user.get_node("axis")
    if axis.scale.x == 1:
        position.x = 20
        ray.cast_to.x = 200
    elif axis.scale.x == -1:
        ray.cast_to.x = -200
        position.x = -20

func cast_beam(_user):
    if laser:
        pass

    #    ray.force_raycast_update()
    #    ray.add_exception(user)
    #
    #    if ray.is_colliding():    
    #        beam_end.global_position = ray.get_collision_point()
    #  
    #    else:
    #        beam_end.global_position = (ray.cast_to + user.global_position)
    #        pass
    #
    #    #beam.rotation = ray.cast_to.angle()
    #    #beam.rotation = rotation
    #    beam.region_rect.end.x = beam_end.position.length()
    else:
        pass

#######################################################################################################################
func shoot(_pos):
    #var pos = _pos * get_parent().scale
    var b = bullet.instance()
    var a = (_pos - global_position).angle()

    b.start(global_position, a + rand_range(-0.05, 0.05))
    Scene.add_child(b)


#######################################################################################################################

func switch():
    yield(get_tree().create_timer(1), "timeout")
    switch_off = false
    #beam.visible = true
    yield(get_tree().create_timer(1), "timeout")
    switch_off = true
    #beam.visible = false

func delay():
    delay_off = false
    yield(get_tree().create_timer(1), "timeout")
    delay_off = true

func _physics_process(_delta):
    #update()
    #cast_beam(user)
    pass

func _draw():
    pass

func modulate_off():
    for i in targets:
        if i != current_target:
            i.modulate = Color(1, 1, 1, 1)

func _on_sight_body_entered(body: Node) -> void:
    target_number = 0
    if body.is_in_group("Enemy"):
        targets.append(body)
        if body == targets[0]:
            body.modulate = Color(1, 1, 3, 1)
            current_target = body
        else:
            body.modulate = Color(1, 1, 1, 1)

#        if targets.size() >= 1 and target_number < targets.size() - 1:
#            if !current_target:
#                current_target = targets[target_number]
#                current_target.modulate = Color(1, 1, 1, 1)
#        pass # Replace with function body.

func _on_sight_body_exited(body: Node) -> void:
    #print('Equipment/FireArms.gd: ', target_number)
    targets.erase(body)
    current_target = null
    body.modulate = Color(1, 1, 1, 1)
    #if body == current_target and target_number > 0:
    if target_number >= 0 and targets.size() > 0:
        target_number -= 1
        current_target = targets[target_number]
        current_target.modulate = Color(1, 1, 3, 1)
    elif targets.size() > 0:
        target_number += 1
        current_target = targets[target_number]
        current_target.modulate = Color(1, 1, 3, 1)

