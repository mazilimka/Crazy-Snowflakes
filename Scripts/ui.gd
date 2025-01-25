extends CanvasLayer

@onready var timer_to_shift := %TimerToShift
@onready var bar_before_slowing := %BarBeforeSlowing
@onready var press_shift: Label = %PressShift
@onready var shift_counter_bar: ProgressBar = %ShiftCounterBar

var shift_counter := 0
var tween_text_counter := 0
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
	progress_before_slowing = randi_range(3, 8)
	shift_counter_bar.max_value = randi_range(5, 8)


func _process(delta: float) -> void:
	bar_before_slowing.value = timer_to_shift.get_time_left()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shift") and not can_slowing:
		launch_slow_snowflakes_comp()
		shift_counter += 1
		shift_count(shift_counter)
		can_slowing = true
		press_shift_tween.kill()
		press_shift.hide()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("escape") or Input.is_action_just_pressed("escape"):
		%StartWindow.open()
		get_viewport().set_input_as_handled()


func shift_count(counter: int):
	shift_counter_bar.value = counter
	if shift_counter_bar.value == shift_counter_bar.max_value:
		get_tree().paused = true
		$VictoryWindow.show()


func timer_to_shift_timeout():
	can_slowing = false
	press_shift.show()
	text_tween()


func launch_slow_snowflakes_comp():
	for node in %Snowflokes.get_children():
		node.launch_slow_comp()


func text_tween():
	press_shift_tween = get_tree().create_tween().set_loops(2)
	press_shift_tween.tween_property(press_shift, 'modulate', Color.RED, 0.15)
	press_shift_tween.tween_property(press_shift, 'modulate', Color.WHITE, 0.15)
	await press_shift_tween.finished
	press_shift_tween = get_tree().create_tween()
	press_shift_tween.tween_property(press_shift, 'modulate', Color("ffffff00"), 0.15)
	await press_shift_tween.finished
	press_shift.hide()
