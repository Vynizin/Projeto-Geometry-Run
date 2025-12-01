extends CharacterBody2D

@export var speed = 200.0
@export var speed_increase: float = 15.0
@export var speed_interval: float = 3.0
@export var max_speed: float = 600.0


@export var jump_force = 350.00
@export var jump_release_multiplier := 0.5  # ← ADICIONADO (controla quanto corta o pulo)

@export var gravity = 1200.0
@export var rotation_step = 90.0
@export var rotation_speed = 10.0

@onready var explosion_scene = preload("res://Scenes/DeathExplosion.tscn")
@onready var ray_left = $RaycastLeft
@onready var ray_right = $RaycastRight
@onready var rhythm_manager = RhythmManager


var speed_timer = 0.0
var spawn_position: Vector2
var target_rotation = 0.0
var is_dead = false
var is_jumping = false   # ← ADICIONADO
var score: float = 0.0
var coyote_time := 0.12        # tempo que ainda pode pular após sair do chão
var coyote_timer := 0.0
var jump_buffer_time := 0.15   # tempo que o pulo fica guardado após apertar
var jump_buffer_timer := 0.0
var start_x: float
var end_x: float




func _ready():
	spawn_position = global_position
	
	#RhythmManager.beat.connect(_on_beat)
	#if rhythm_manager:
		#rhythm_manager.connect("beat", Callable(self, "_on_beat"))
	#else:
		#print("ERRO: RhythmManager não encontrado!")
#
#func _on_beat():
	#print("BEAT!!!")



func _physics_process(delta):
	ray_left.enabled = false
	ray_right.enabled = false
	# COYOTE TIME
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

# JUMP BUFFER
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if is_dead:
		return

	# -------------------------
	# SISTEMA DE VELOCIDADE
	# -------------------------
	speed_timer += delta
	if speed_timer >= speed_interval:
		speed_timer = 0.0
		_increase_speed()

	velocity.x = speed

	# -------------------------
	# APLICAR GRAVIDADE
	# -------------------------
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false   # ← reseta o estado ao tocar o chão

	# -------------------------
	# PULO VARIÁVEL
	# -------------------------
# PULO sem delay (coyote time + jump buffer)
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = -jump_force
		is_jumping = true
		jump_buffer_timer = 0
		coyote_timer = 0
		target_rotation += deg_to_rad(rotation_step)


	# cortar pulo ao soltar
	if is_jumping and Input.is_action_just_released("jump"):
		if velocity.y < 0:  # só corta enquanto estiver subindo
			velocity.y *= jump_release_multiplier
		is_jumping = false

	# -------------------------
	# ROTAÇÃO DO VISUAL
	# -------------------------
	$Visual.rotation = lerp_angle($Visual.rotation, target_rotation, rotation_speed * delta)


	# -------------------------
	# DETECÇÃO DE MORTE
	# -------------------------
	if (ray_left.is_colliding() or ray_right.is_colliding()) and not is_dead:
		die()
		return

	if Input.is_action_just_pressed("debug"):
		die()

	# aumenta score baseado na velocidade real
# PROGRESSO DA FASE
	var total = end_x - start_x
	var atual = global_position.x - start_x
	var progresso = clamp((atual / total) * 100.0, 0, 100)

# atualiza HUD
	var level = get_tree().current_scene
	var progress = level.get_progress(global_position.x)

	var hud = level.get_node("HUD/ScoreLabel")
	hud.text = str(int(progress)) + "%"

	move_and_slide()


func die():
	score = 0
	if is_dead:
		return

	is_dead = true
	print("MORRI: pos=", global_position)

	# explosão
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	explosion.explode()

	hide()
	velocity = Vector2.ZERO

	# delay pro efeito aparecer
	get_tree().create_timer(0.45).timeout.connect(func():
		get_tree().reload_current_scene()
	)


func _increase_speed():
	if speed < max_speed:
		speed += speed_increase

func disable_death():
	is_dead = true   # evita qualquer futura chamada de die()
