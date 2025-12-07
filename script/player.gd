extends CharacterBody2D

@onready var progress_bar: ProgressBar = $ProgressBar

#damage variable
var is_in_damage_area := false
var damage_timer := 0.0

# Movement speed of the player
var SPEED  = 200.0
var before_SPEED = 200.0
var current_dir = "none"

func _physics_process(delta):
	player_movement(delta)

	if progress_bar.value == 0:
		get_tree().change_scene_to_file("res://scenes/defeat.tscn")


func player_movement(delta):

	var pressed = false

	# Update direction ONLY when a movement key is pressed
	if Input.is_action_pressed("up"):
		current_dir = "up"
		pressed = true
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		pressed = true
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		pressed = true
	elif Input.is_action_pressed("right"):
		current_dir = "right"
		pressed = true

	# Always move in the current direction
	match current_dir:
		"up":
			velocity = Vector2(0, -SPEED)
		"down":
			velocity = Vector2(0, SPEED)
		"left":
			velocity = Vector2(-SPEED, 0)
		"right":
			velocity = Vector2(SPEED, 0)
		_:
			velocity = Vector2.ZERO  # Only before any key is ever pressed

	# Always walking (since you want no stopping)
	play_anim(1)

	move_and_slide()


func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walking")
		elif movement == 0:
			anim.play("side_idle")
	
	if dir == "right":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walking")
		elif movement == 0:
			anim.play("side_idle")
			
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walking")
		elif movement == 0:
			anim.play("back_idle")
			
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walking")
		elif movement == 0:
			anim.play("front_idle")
			

#taking damage logic
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "enemyarea":
		is_in_damage_area = true
		damage_timer = 0  # apply damage immediately on enter
		progress_bar.value -=1
