extends Node2D

func _ready() -> void:
	var popup = $Panel/MenuButton.get_popup()
	popup.id_pressed.connect(_on_item_selected)
	Global.selected = '9'

func _on_start_game_pressed() -> void:
	$ColorRect.visible = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property($ColorRect, "modulate:a", 1, 2)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_item_selected(id: int):
	Global.selected = $Panel/MenuButton.get_popup().get_item_text(id)
