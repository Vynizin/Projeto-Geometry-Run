
extends Node2D

func _ready():
	#print("EXPLOSÃO READY")
	#print("ANIMS:", $AnimatedSprite2D.sprite_frames.get_animation_names())
	#$AnimatedSprite2D.play($AnimatedSprite2D.sprite_frames.get_animation_names()[0])

	
	if $AnimatedSprite2D:
		$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_finished"))
		#$AnimatedSprite2D.play("explode")
		#$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_finished"))
func explode():
	# Toca a explosão apenas quando essa função for chamada
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("explode")

func _on_finished():
	queue_free()
