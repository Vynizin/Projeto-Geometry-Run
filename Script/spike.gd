extends Area2D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Toquei em:", body)

	if body.is_in_group("player"):
		print("Player detectado!")
		body.die()
