extends VehicleBody3D

const MAX_STEER = 0.4
const MAX_RPM = 500
const MAX_TORQUE = 200
const HORSE_POWER = 300

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func calc_engine_force(accel, rpm):
	return accel * MAX_TORQUE * (1 - rpm / MAX_RPM)

func _physics_process(delta: float) -> void:
	steering = lerp(steering,
						Input.get_axis("ui_right", "ui_left") * MAX_STEER,
						delta * 5.0)
	var accel = Input.get_axis("ui_down", "ui_up") * HORSE_POWER
	$back_left.engine_force = calc_engine_force(accel, abs($back_left.get_rpm()))
	$back_right.engine_force = calc_engine_force(accel, abs($back_right.get_rpm()))
	
	var fwd_mps = abs((linear_velocity * transform.basis).z)
	$Label.text = "%d mph" % (fwd_mps * 2.23694)
	
	$center_mass.global_position = $center_mass.global_position.lerp(
												global_position, delta * 20.0)
	$center_mass.transform = $center_mass.transform.interpolate_with(
											transform, delta * 5.0)
	$center_mass/Camera3D.look_at(global_position.lerp(
								global_position + linear_velocity, delta * 5.0))
	#TODO: check and right
