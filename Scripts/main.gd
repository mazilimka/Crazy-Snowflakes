extends Node2D

@onready var showflaces_1: Sprite2D = $Showflaces1
@onready var snowflake_scene := preload("res://Scenes/good_snowflake.tscn")
@onready var health_label: Label = %Health
@onready var shake_camera: Camera2D = $ShakeCamera
@onready var timer_to_shift := %TimerToShift

var max_number_of_shift := randi_range(6, 10)
var timer := 0.0
var global_timer := 0.0
var timer_for_rest := 0.0
var time_to_game_speeding_up := 7.0
var time_to_launch_snowflakes := randf_range(1, 3)
var time_to_snowf_incr_from := 0.8
var time_to_snowf_incr_to := 2.0
var min_time_from_snowf := 0.1
var min_time_to_snowf := 0.5
var camera_shake_noice: FastNoiseLite

func _ready() -> void:
	Global.Main = self
	camera_shake_noice = FastNoiseLite.new()
	%ShiftCounterBar.max_value = max_number_of_shift


func _process(delta: float) -> void:
	timer += delta
	if timer >= time_to_launch_snowflakes:
		for i in randi_range(1, 4):
			#launch_snowflake()
			pass
		timer = 0
		time_to_launch_snowflakes = randf_range(time_to_snowf_incr_from, time_to_snowf_incr_to)


func launch_snowflake():
	var snowflake_instance: Area2D = snowflake_scene.instantiate()
	%Snowflokes.add_child(snowflake_instance, true)
	snowflake_instance.global_position.x = randf_range(50, 760)
	Global.counter_of_snowflakes += 1
	Snowflakes.set_difficulty(Global.counter_of_snowflakes)
	set_difficulty(Global.counter_of_snowflakes)


func update_health(health: int):
	health_label.text = str(health) + "/3"


func set_difficulty(difficult: int):
	if difficult % 50 == 0:
		if time_to_snowf_incr_from >= min_time_to_snowf:
			time_to_snowf_incr_to -= 0.1
			time_to_snowf_incr_to = max(time_to_snowf_incr_to, min_time_to_snowf)
			return
		time_to_snowf_incr_from -= 0.1
		time_to_snowf_incr_from = max(time_to_snowf_incr_from, min_time_from_snowf)


func set_def_difficulty():
	time_to_snowf_incr_from = 0.8
	time_to_snowf_incr_to = 2.0


func restart_game():
	get_tree().paused = true
	%PressShift.hide()
	%DeathWindow.open()
	if Global.is_endless_mode:
		Global.UI.score.text


func start_camera_shake(intensity: float):
	var camera_offset := camera_shake_noice.get_noise_1d(Time.get_ticks_usec())
	shake_camera.offset = Vector2(camera_offset, camera_offset) * intensity
