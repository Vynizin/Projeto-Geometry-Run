# BackgroundLooper.gd
extends Node2D

@export var parallax_factor: float = 1.0   # 1.0 = mesmo movimento da câmera; <1 = parallax
@export var gap_epsilon: float = 1.0       # folga em pixels para evitar gaps visuais

@onready var bg1: Sprite2D = $bg1
@onready var bg2: Sprite2D = $bg2
@onready var cam: Camera2D = get_viewport().get_camera_2d()

var tex_width: float = 0.0
var last_cam_x: float = 0.0
var started_moving: bool = false

func _ready():
	if not bg1.texture:
		push_error("bg1.texture não configurada!")
		return
	# largura exibida (considera scale X)
	tex_width = bg1.texture.get_width() * bg1.scale.x

	# Garantir posições locais limpas
	bg1.position = Vector2.ZERO
	bg2.position = Vector2(tex_width, 0)

	if cam:
		last_cam_x = cam.global_position.x

func _process(delta):
	if not cam:
		return

	var cam_move = cam.global_position.x - last_cam_x

	# só ativa movimento quando a câmera efetivamente se mover (evita mover no começo)
	if cam_move != 0:
		started_moving = true

	if started_moving:
		# mover os tiles inversamente ao deslocamento da câmera
		var move_amount = cam_move * parallax_factor
		# como cam_move é a diferença da câmera desde o frame anterior,
		# aplicar move_amount diretamente aos bg (inverter para que cam->direita = bg->esquerda)
		bg1.global_position.x -= move_amount
		bg2.global_position.x -= move_amount

		# calcula borda esquerda visível da câmera
		var view_w = get_viewport_rect().size.x
		var cam_left = cam.global_position.x - view_w * 0.5

		# se o lado direito do bg ficou à esquerda da borda visível -> reposicionar
		if (bg1.global_position.x + tex_width) < (cam_left - gap_epsilon):
			# posiciona bg1 à direita de bg2 (local position pra evitar acumular erro)
			bg1.position.x = bg2.position.x + tex_width
			# atualiza global_position para consistência
			bg1.global_position = bg1.get_global_transform().origin

		if (bg2.global_position.x + tex_width) < (cam_left - gap_epsilon):
			bg2.position.x = bg1.position.x + tex_width
			bg2.global_position = bg2.get_global_transform().origin

	last_cam_x = cam.global_position.x
