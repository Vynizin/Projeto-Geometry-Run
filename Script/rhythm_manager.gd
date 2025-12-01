extends Node

@export var bpm : float = 110.0
@export var start_delay := 0.0
@export var music_player_path := NodePath("../MusicPlayer")


signal beat(beat_index, playback_time)


var seconds_per_beat : float
var last_beat_index := -1
var music_player : AudioStreamPlayer2D

func _ready():
	seconds_per_beat = 60.0 / bpm
	music_player = get_node(music_player_path)
	print("Buscando:", music_player_path)
	print("Achado:", get_node_or_null(music_player_path))



func _process(_delta):
	if music_player == null or not music_player.playing:
		return

	var t = music_player.get_playback_position() - start_delay
	if t < 0:
		return

	var beat_i = int(t / seconds_per_beat)

	if beat_i != last_beat_index:
		last_beat_index = beat_i
		print("BEAT:", beat_i)
		emit_signal("beat", beat_i, t)
