extends Control

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_sair_pressed():
	get_tree().quit()


func _ready():
	$CanvasLayer/Control/VBoxContainer.modulate.a = 0
	$CanvasLayer/Control/TextureRect.modulate.a = 0

	var tween = create_tween()
	tween.tween_property($CanvasLayer/Control/TextureRect, "modulate:a", 1, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_property($CanvasLayer/Control/VBoxContainer, "modulate:a", 1, 0.5).set_delay(0.2)
