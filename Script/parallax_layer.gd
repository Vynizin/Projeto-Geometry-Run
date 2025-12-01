extends Node2D

var base_scale := Vector2.ONE
var pulse_scale := Vector2(1.05, 1.05)
var lerp_speed := 8.0

func _ready():
	base_scale = scale
	#get_node("root/GeometryDash/Main/RhythmManager").beat.connect(_on_beat)

func _on_beat():
	scale = pulse_scale

func _process(delta):
	scale = scale.lerp(base_scale, delta * lerp_speed)
