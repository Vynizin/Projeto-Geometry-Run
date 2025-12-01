extends Camera2D

@export var pulse_amount := 0.90
@export var pulse_return_speed := 10.0
@export var shake_strength := 0.0
@export var shake_decay := 8.0


var base_zoom: Vector2
var target_zoom: Vector2
var shake_offset := Vector2.ZERO
var current_shake := 0.0

func _ready():
	base_zoom = zoom
	target_zoom = base_zoom

	var rm = get_node_or_null("../../RhythmManager")

	if rm:
		rm.beat.connect(_on_beat)
	else:
		print("❌ RhythmManager NÃO encontrado!")

	if screen_flash:
		print("✔ ScreenFlash encontrado!")
	else:
		print("❌ ScreenFlash NÃO encontrado!")


func _on_beat(beat_index: int, playback_time: float):

	var t = playback_time
	var pulse_this_beat := false
	var flash_this_beat := false

	if (t >= 17 and t < 33) or (t >= 52 and t < 70) or (t >= 87 and t < 104):
		pulse_this_beat = true
		flash_this_beat = true
	else:
		if beat_index % 4 == 0:
			pulse_this_beat = true
			flash_this_beat = true

	if not pulse_this_beat:
		return

	target_zoom = base_zoom * pulse_amount




func _process(delta):
	zoom = zoom.lerp(target_zoom, delta * pulse_return_speed)
	target_zoom = target_zoom.lerp(base_zoom, delta * pulse_return_speed * 0.6)

	if current_shake > 0.01:
		shake_offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * current_shake
		offset = shake_offset
		current_shake = lerp(current_shake, 0.0, delta * shake_decay)
	else:
		offset = Vector2.ZERO
