extends StaticBody2D

func is_side_hit(player_pos: Vector2) -> bool:
	var offset = player_pos.x - global_position.x
	return abs(offset) > 10
