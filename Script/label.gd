extends Label

func _ready():
	# efeito de aparecer
	modulate.a = 0
	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE)

	# efeito pulsando (loop infinito)
	var pulse = create_tween().set_loops()
	pulse.tween_property(self, "scale", Vector2(1.05, 1.05), 1.0)
	pulse.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0)
