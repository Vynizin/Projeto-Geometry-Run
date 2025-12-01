extends Node2D

@export var rhythm_manager_path: NodePath
var rhythm_manager
var player_start_x: float
var finish_x: float


func _ready():
	rhythm_manager = get_node(rhythm_manager_path)

	$MusicPlayer.seek(0)
	$MusicPlayer.play()

	# garante que a UI NÃO aparece no início
	$VitoriaUI.visible = false
	# o Area2D de vitória

	var player = get_tree().current_scene.get_node("Player")
	player_start_x = player.global_position.x
	finish_x = $CondicaoVitoria.global_position.x

	# passa as posições pro player (opcional, mas garante coerência)
	if player:
		player.start_x = player_start_x
		player.end_x = finish_x
	print("player_start_x=", player_start_x, " finish_x=", finish_x, " player.x=", player.global_position.x)

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

func get_progress(player_x: float) -> float:
	# total absoluto entre start e finish (cobre direções invertidas)
	var total = abs(finish_x - player_start_x)
	# evita divisão por zero (finish não definido ou igual ao start)
	if total == 0:
		return 0.0
	# distância absoluta percorrida desde o start
	var done = abs(player_x - player_start_x)
	# porcentagem e clamp entre 0 e 100
	return clamp((done / total) * 100.0, 0.0, 100.0)
