extends ParallaxBackground

@export var player_path: NodePath
@export var parallax_factor := 0.2
var player

func _ready():
	player = get_node(player_path)

func _process(delta):
	if player:
		scroll_offset.x += player.velocity.x * parallax_factor * delta
