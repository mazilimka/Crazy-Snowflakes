extends CharacterBody2D

@onready var particle_material = preload("res://new_particle_process_material.tres")
@onready var broken_window_sound: AudioStreamPlayer = $BrokenWondowSound
@onready var music: AudioStreamPlayer = $Music

@export_category("Movement")
@export var max_speed := 220.0
@export var acceleration := 50.0
@export var friction := 50.0
@export_category("Jump")
@export var gravity := 2000.0
@export var jump_velocity := -750.0
@export var max_jump_speed := -200.0

var array_sounds := [
	preload("res://assets_and_referens/sounds/00165.mp3"), 
	preload("res://assets_and_referens/sounds/glass-break-wine-glass_fkyjgn4d.mp3"),
	preload("res://assets_and_referens/sounds/glass-break-wine-glass_mk-6f24d.mp3"),
	preload("res://assets_and_referens/sounds/glass-shatter_mjxklono.mp3")
]

var center_of_screen := 400.0
var is_first_touch := true
var was_on_floor := false
var save_tween: Tween
var save_mode_timer := 0.0
var is_save_mode := false
var max_jump_time := 0.5
var hold_time := 0.0
var is_jumping := false
var health := 3:
	set(value):
		if health != value:
			health = value
			if health == 0:
				death()
				return
			Global.UI.health_tween()
			Global.Main.update_health(health)
			camera_shake()

func _ready() -> void:
	Global.Player = self
	if Global.is_mobile:
		mobile_controlls_tween()
	else:
		for node in %Controlls.get_children(): node.queue_free()
	$FallParticles.emitting = false


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
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
		is_jumping = false
	
	if Input.is_action_pressed("jump") and hold_time < max_jump_time and not is_jumping:
		hold_time += delta
		velocity.y = lerp(jump_velocity, max_jump_speed, hold_time / max_jump_time)
		get_viewport().set_input_as_handled()
	if Input.is_action_just_released("jump"):
		is_jumping = true
		hold_time = 0.0
	
	move_and_slide()
	
	var collision := move_and_collide(Vector2.DOWN, false)
	if collision and was_on_floor:
		if collision.get_collider().name == "DownWall":
			if not is_first_touch:
				launch_particles()
			is_first_touch = false
	was_on_floor = is_on_floor()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		await Global.await_a_few_msec(0.1) == true
		get_viewport().set_input_as_handled()


func mobile_controlls_tween():
	get_tree().paused = true
	
	var tween1 := get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_loops(3)
	tween1.tween_property(%LeftRect, "modulate", Color("a1ad0000"), 0.5)
	tween1.tween_property(%LeftRect, "modulate", Color("a1ad00"), 0.5)
	
	var tween2 := get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_loops(3)
	tween2.tween_property(%RightRect, "modulate", Color("e4a1d200"), 0.5)
	tween2.tween_property(%RightRect, "modulate", Color("e4a1d2"), 0.5)
	
	var tween3 := get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).set_loops(3)
	tween3.tween_property(%JumpRect, "modulate", Color("ff740200"), 0.5)
	tween3.tween_property(%JumpRect, "modulate", Color("ff7402"), 0.5)
	
	await tween1.finished
	await tween2.finished
	await tween3.finished
	
	tween1 = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween1.tween_property(%LeftRect, "modulate", Color("a1ad0000"), 0.1)
	
	tween2 = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween2.tween_property(%RightRect, "modulate", Color("e4a1d200"), 0.1)
	
	tween3 = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween3.tween_property(%JumpRect, "modulate", Color("ff740200"), 0.1)
	
	await tween1.finished
	await tween2.finished
	await tween3.finished
	
	get_tree().paused = false


func camera_shake(intensity: float = 20.0, time: float = 0.2) -> Tween:
	var camera_tween := create_tween()
	camera_tween.tween_method(Global.Main.start_camera_shake, intensity, 1.0, 0.2)
	return camera_tween


func taked_damage():
	broken_window_sound.stream = array_sounds.pick_random()
	broken_window_sound.play()
	
	is_save_mode = true
	save_tween = get_tree().create_tween().set_loops(4)
	save_tween.tween_property(%Heart, "visible", false, 0.1)
	save_tween.tween_property(%Heart, "visible", true, 0.1)
	await save_tween.finished
	is_save_mode = false


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
