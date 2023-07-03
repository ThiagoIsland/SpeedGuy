extends KinematicBody2D

const GRAVITY = 900
const MAX_SPEED = 350
const JUMP_FORCE = -1200	
var player_health = 3
var max_health = 3
var hurted = false
var motion = Vector2()
var is_on_floor = false
var knockback_dir = 1
var knockback_int = 300
var jumps_left = 2

signal change_Life(player_health)

func _ready() -> void:
	connect("change_life", get_parent().get_node("HUD/HBoxContainer/Holder2/lifes"), "on_change_life")
	emit_signal("change_life", max_health)
	position.x = Global.checkpoint_pos
func _physics_process(delta: float) -> void:
	motion.y += GRAVITY * delta
	motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	
	motion.x = 0
	if Input.is_action_pressed("ui_right"):
		motion.x += MAX_SPEED
		$texture.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		motion.x -= MAX_SPEED
		$texture.flip_h = true

	motion = move_and_slide(motion, Vector2.UP)

	if is_on_floor and Input.is_action_just_pressed("ui_accept"):
		if jumps_left > 0:
			motion.y = JUMP_FORCE
			is_on_floor = false
			jumps_left -= 1

	is_on_floor = is_on_floor()

	_set_animation()

func is_on_floor() -> bool:
	var raycast = move_and_collide(Vector2(0, 1))
	return raycast != null
	

func _set_animation() -> void:
	if motion.y < 0:
		$anim.play("jump")
		$jumpFx.play()
	elif motion.x != 0:
		$anim.play("run")
	else:
		$anim.play("idle")
	if hurted:
		$anim.play("hit")
	if is_on_floor:
		jumps_left = 2

#func knockback():
	#motion.x = -knockback_dir * knockback_int
	#motion = move_and_slide(motion)
	
func _on_hurtbox_body_entered(body):
	player_health -= 1
	hurted = true
	emit_signal("change_Life", player_health)
	#knockback()
	yield(get_tree().create_timer(0.5), "timeout")
	hurted = false
	if player_health <1: 
		queue_free()
		get_tree().reload_current_scene()

func hit_checkpoint():
	Global.checkpoint_pos = position.x

#func get_direction() -> Vector2:
#	if motion == motion.PAUSE:
#		return Vector2.ZERO
#	return Vector2(
#		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
#		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0)
	
