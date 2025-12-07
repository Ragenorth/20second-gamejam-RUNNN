extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var healthbar: ProgressBar = $Healthbar

var player: CharacterBody2D
var speed: float = 150.0
var hp: int = 10

#grid variable
var grid_size := 16
var move_time := 0.15     # how long each tile movement lasts
var move_progress := 0.0
var start_pos: Vector2
var target_pos: Vector2
var is_moving := false

signal dying

func _ready():
	var players = get_tree().get_nodes_in_group("player")

	if players.size() > 0:
		player = players[0]
	else:
		print("No player found in group 'player'")
		

func _physics_process(delta):
	if player == null:
		return

	if is_moving:
		move_progress += delta / move_time
		global_position = start_pos.lerp(target_pos, move_progress)

		if move_progress >= 1.0:
			global_position = target_pos
			is_moving = false

		return  # do not choose new direction while moving

	# ----- If not moving: choose next grid tile -----

	var dir = (player.global_position - global_position).normalized()

	# pick cardinal direction only (no diagonals)
	var grid_dir = Vector2(
		sign(dir.x),
		sign(dir.y)
	)

	# only move horizontally OR vertically, whichever is stronger
	if abs(dir.x) > abs(dir.y):
		grid_dir.y = 0
	else:
		grid_dir.x = 0

	# compute tile target
	start_pos = global_position
	target_pos = start_pos + grid_dir * grid_size

	# flip animation
	sprite.flip_h = grid_dir.x > 0

	move_progress = 0.0
	is_moving = true


#death logic
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.name == "attack_area":
		## decrease HP by 1
		#healthbar.value -= 1
		#$AnimatedSprite2D.play("damage")
#
		## check if dead
		#if healthbar.value <= 0:
			#$AnimatedSprite2D.play("death")
			#dying.emit()
			#queue_free()  # remove the hitbox if you want
