extends VBoxContainer

@onready var tree := get_tree()

func _on_start_pressed() -> void:
	tree.change_scene_to_file("res://Scenes/game.tscn")

func _on_exit_pressed() -> void:
	tree.quit(0)
