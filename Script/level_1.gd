extends Node2D

@export var rhythm_manager_path: NodePath
var rhythm_manager

func _ready():
	rhythm_manager = get_node(rhythm_manager_path)

	$MusicPlayer.seek(0)
	$MusicPlayer.play()

	# garante que a UI NÃO aparece no início
	$VitoriaUI.visible = false


func win():
	# desativa morte
	# desativa morte
	var player = get_tree().get_current_scene().get_node("Player")
	if player:
		player.disable_death()

	var screen = $VitoriaUI
	screen.visible = true

	var anim = $VitoriaUI/AnimationPlayer

	# toca animação completa
	if anim.has_animation("win_animation"):
		anim.play("win_animation")

	# só pausa o jogo DEPOIS de tocar a animação
	get_tree().paused = true





func _on_condicao_vitoria_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		win()


func _on_texture_button_pressed() -> void:
	var anim = $VitoriaUI/AnimationPlayer

	# toca fade out dos dois
	if anim.has_animation("fade_out"):
		anim.play("fade_out") # anima tudo

	# espera acabar antes de reiniciar
	await anim.animation_finished
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.
