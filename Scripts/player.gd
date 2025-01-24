extends CharacterBody2D

@export_category("Movement")
@export var max_speed := 220.0
@export var acceleration := 50.0
@export var friction := 50.0
@export_category("Jump")
@export var gravity := 1800.0
@export var jump_max_speed := -700.0
@export var jump_acceleration := -50.0
@export var jump_deceleration := -50.0

var health := 3:
	set(value):
		if health != value:
			health = value
			if health == 0:
				death()
			Global.Main.update_health(health)

func _ready() -> void:
	Global.Player = self


func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, (direction * max_speed), (acceleration * delta))
	else:
		velocity.x = lerp(velocity.x, 0.0, (friction * delta))
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_max_speed
	
	move_and_slide()


func death():
	queue_free()
	Global.Main.restart_game()
