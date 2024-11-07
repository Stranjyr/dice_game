extends Node3D


var dice_obj = preload("res://scenes/game_objects/dice_6_sides.tscn")

var dice_list = []
const pojection_dist = 1000


var mouse_3d_pos: Vector3 = Vector3(0, 0, 0)

var mouse_held = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if mouse_held:
		for d in dice_list:
			d.apply_force_towards_mouse(mouse_3d_pos, delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		if event.is_pressed():
			mouse_held = true
		else:
			mouse_held = false
			for d in dice_list:
				d.roll_die(Vector3(-15, 0, randf_range(-2, 2)))
				
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			var new_die = dice_obj.instantiate()
			new_die.position = mouse_3d_pos
			new_die.scale = Vector3(3, 3, 3)
			add_child(new_die)
			dice_list.append(new_die)
		
	if event is InputEventMouseMotion:
		get_mouse_world_position(event.position)
		
func get_mouse_world_position(mouse_2d_pos: Vector2):
	var space = get_world_3d().direct_space_state
	var from = get_viewport().get_camera_3d().project_ray_origin(mouse_2d_pos)
	var to = get_viewport().get_camera_3d().project_position(mouse_2d_pos, pojection_dist)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	
	var result = space.intersect_ray(params)
	if not result.is_empty():
		mouse_3d_pos = result.position
		mouse_3d_pos.y = 5

	
