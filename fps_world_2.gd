extends Node3D

@export var next_level = "none"

func _process(delta: float) -> void:
	if len(get_tree().get_nodes_in_group("Enemy")) <= 0:
		await get_tree().create_timer(0.25).timeout
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		OS.alert("You win!")
		if next_level == "none":
			get_tree().quit()
		else:
			get_tree().call_deferred("change_scene_to_file", next_level)
