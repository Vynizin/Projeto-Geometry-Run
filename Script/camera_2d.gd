extends Camera2D

@export var pulse_amount := 0.90          # 0.90 = pulso forte, 0.95 = fraco
@export var pulse_return_speed := 10.0    # velocidade de retorno
@export var shake_strength := 0.0         # opcional shake
@export var shake_decay := 8.0

var base_zoom: Vector2
var target_zoom: Vector2
var shake_offset := Vector2.ZERO
var current_shake := 0.0

func _ready():
	base_zoom = zoom
	target_zoom = base_zoom

	# pega o RhythmManager subindo 3 níveis (Level → Main)
	var rm = get_node_or_null("../../RhythmManager")

	if rm == null:
		print("❌ RhythmManager NÃO encontrado!")
	else:
		print("✔ RhythmManager encontrado!")
		rm.beat.connect(_on_beat)


func _on_beat(beat_index: int, playback_time: float):
	print("RECEBI BEAT:", beat_index, "tempo:", playback_time)

	var t = playback_time
	var pulse_this_beat := false

	# --- Partes agitadas ---
	if (t >= 17 and t < 33) \
	or (t >= 52 and t < 70) \
	or (t >= 87 and t < 104):
		pulse_this_beat = true

	# --- Partes normais (bate só no forte) ---
	else:
		if beat_index % 4 == 0:
			pulse_this_beat = true

	if not pulse_this_beat:
		return

	target_zoom = base_zoom * pulse_amount

	if shake_strength > 0.0:
		current_shake = shake_strength



func _process(delta):
	# suaviza a câmera de volta
	zoom = zoom.lerp(target_zoom, delta * pulse_return_speed)
	target_zoom = target_zoom.lerp(base_zoom, delta * pulse_return_speed * 0.6)

	# shake
	if current_shake > 0.01:
		shake_offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * current_shake
		offset = shake_offset
		current_shake = lerp(current_shake, 0.0, delta * shake_decay)
	else:
		offset = Vector2.ZERO
