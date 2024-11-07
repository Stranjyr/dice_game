extends RigidBody3D

var move_to_mouse: bool = false
var is_rolling: bool = false

const pid_param = Vector3(2, 0, -.005)
const min_movement: Vector3 = Vector3(.1, .1, .1)
const angular_impulse = 4

var last_error = Vector3(0, 0, 0)
var pid_i_val = Vector3(0, 0, 0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func apply_force_towards_mouse(target_location: Vector3, delta_t: float) -> void:
	if not is_rolling:
		move_to_mouse = true
		var error = (target_location-self.position)
		var P =  error * pid_param.x
		pid_i_val = pid_i_val + error*(delta_t)*pid_param.y
		var D = (error-last_error)/(delta_t)* pid_param.z
		self.apply_force(P+pid_i_val+D)
		print("Mouse Pos: ", target_location)
		print("Dice Pos: ", self.position)
		print("Force Applied: ", (P+pid_i_val+D))

func roll_die(target_direction: Vector3) -> void:
	if move_to_mouse and not is_rolling:
		self.apply_impulse(target_direction)
		self.apply_torque_impulse(Vector3(randf_range(-angular_impulse, angular_impulse), randf_range(-angular_impulse, angular_impulse), randf_range(-angular_impulse, angular_impulse)))
		move_to_mouse = false
		is_rolling = true
		pid_i_val = Vector3(0, 0, 0)

func reset_rolling() -> void:
	if is_rolling and not move_to_mouse and self.linear_velocity.abs() < min_movement and self.angular_velocity.abs() < min_movement:
		is_rolling = false

func _physics_process(delta: float) -> void:
	reset_rolling()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
