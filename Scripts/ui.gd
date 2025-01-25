extends Control

@onready var timer_to_shift := %TimerToShift
@onready var bar_before_slowing := %BarBeforeSlowing
@onready var press_shift: Label = %PressShift

var press_shift_tween: Tween
var can_slowing := true
var progress_before_slowing := 0: 
	set(value):
		progress_before_slowing = value
		bar_before_slowing.max_value = progress_before_slowing
		bar_before_slowing.value = progress_before_slowing
		timer_to_shift.wait_time = progress_before_slowing
		timer_to_shift.start()

func _ready() -> void:
	timer_to_shift.timeout.connect(timer_to_shift_timeout)
	Global.UI = self
	progress_before_slowing = 3


func _process(delta: float) -> void:
	bar_before_slowing.value = timer_to_shift.get_time_left()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shift") and not can_slowing:
		launch_slow_snowflakes_comp()
		can_slowing = true
		press_shift_tween.kill()
		press_shift.hide()

func timer_to_shift_timeout():
	can_slowing = false
	press_shift.show()
	text_tween()


func launch_slow_snowflakes_comp():
	for node in %Snowflokes.get_children():
		node.launch_slow_comp()

func text_tween():
	press_shift_tween = get_tree().create_tween().set_loops(2)
	press_shift_tween.tween_property(press_shift, 'modulate', Color.RED, 0.3)
	press_shift_tween.tween_property(press_shift, 'modulate', Color.WHITE, 0.3)
	await press_shift_tween.finished
	press_shift_tween = get_tree().create_tween()
	press_shift_tween.tween_property(press_shift, 'modulate', Color("ffffff00"), 0.2)
	await press_shift_tween.finished
	press_shift.hide()
