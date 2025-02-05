extends Area3D

@export var next_level = ""
@onready var HUD = get_tree().get_first_node_in_group("HUD")

func _on_body_entered(body: Node3D) -> void:
	if body. is_in_group("Player"):
		if next_level != "":
			var lvl = "res://" + next_level + ".tscn"
			HUD.popup.show()
			HUD.popup_lbl.text = "loading..."
			await get_tree().create_timer(0.1).timeout
			get_tree().call_deferred("change_scene_to_file", lvl)
		else:
			OS.alert("NO NEXT LEVEL")
	pass
