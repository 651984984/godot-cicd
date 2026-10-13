extends CharacterBody2D
@export var respawn_point: Marker2D




const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const ACCELERATION := 2000.0
const FRICTION := 2400.0


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	move_and_slide()
	_update_animation(direction)


func _update_animation(direction: float) -> void:

	if direction != 0.0:
		sprite.flip_h = direction < 0.0
	if not is_on_floor():
		sprite.play("Jump")
	elif absf(velocity.x) > 10.0:
		sprite.play("Walk")
	else:
		sprite.play("Idle")




func _on_kill_zone_body_entered(body: CharacterBody2D) -> void:
	global_position = respawn_point.global_position
	print("Died")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Start_Menu.tscn")
