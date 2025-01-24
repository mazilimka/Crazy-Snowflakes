extends CharacterBody2D

@onready var particle_material = preload("res://new_particle_process_material.tres")

@export_category("Movement")
@export var max_speed := 220.0
@export var acceleration := 50.0
@export var friction := 50.0
@export_category("Jump")
@export var gravity := 1800.0
@export var jump_max_speed := -700.0
@export var jump_acceleration := -50.0
@export var jump_deceleration := -50.0

var was_on_floor := false
var health := 3:
	set(value):
		if health != value:
			health = value
			if health == 0:
				death()
				return
			Global.Main.update_health(health)
			camera_shake()

func _ready() -> void:
	$FallParticles.emitting = false
	$FallParticles2.emitting = false
	$FallParticles3.emitting = false
	Global.Player = self


func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, (direction * max_speed), (acceleration * delta))
	else:
		velocity.x = lerp(velocity.x, 0.0, (friction * delta))
	
	if not is_on_floor():
		velocity.y += gravity * delta
		was_on_floor = true
	else:
		velocity.y = 0.0
		was_on_floor = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_max_speed
	
	move_and_slide()
	
	var collision = move_and_collide(Vector2.DOWN, false)
	if collision and was_on_floor:
		if collision.get_collider().name == "DownWall":
			launch_particles()
	was_on_floor = is_on_floor()


func camera_shake(intensity: float = 20.0, time: float = 0.2) -> Tween:
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(Global.Main.start_camera_shake, intensity, 1.0, 0.2)
	return camera_tween


func death():
	await camera_shake(1000.0, 1).finished
	queue_free()
	Global.Main.update_health(health)
	Global.Main.restart_game()


func launch_particles():
	var particles = GPUParticles2D.new()
	add_child(particles)
	particles.process_material = particle_material
	particles.global_position = $MarkerForParticle.global_position
	particles.one_shot = true
	particles.explosiveness = 1
	particles.randomness = 0.22
	particles.global_rotation_degrees = 180
	particles.amount = 50
	particles.emitting = true
	await particles.finished
	particles.queue_free()
