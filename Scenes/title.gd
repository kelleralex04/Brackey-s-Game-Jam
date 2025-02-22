extends Node2D

func _on_start_game_pressed() -> void:
	$ColorRect.visible = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property($ColorRect, "modulate:a", 1, 2)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
