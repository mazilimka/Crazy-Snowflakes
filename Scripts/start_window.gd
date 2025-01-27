extends PanelContainer

var is_just_start := true

func _ready() -> void:
	%Start.pressed.connect(_start_pressed)
	%Resume.pressed.connect(_resume_pressed)
	title_tween()


func open():
	get_tree().paused = true
	is_just_start = false
	show()
	%Start.hide()
	%Resume.show()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		Global.is_mobile = true
	if Input.is_action_just_pressed("escape") and not is_just_start:
		_resume_pressed()
		get_viewport().set_input_as_handled()


func title_tween():
	var tween_rot := get_tree().create_tween().set_loops(-1).set_ease(Tween.EASE_IN_OUT).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_rot.tween_property(%Title, 'rotation', deg_to_rad(-10), 3)
	tween_rot.tween_property(%Title, 'rotation', deg_to_rad(+10), 3)
	
	var tween_scale := get_tree().create_tween().set_loops(-1).set_ease(Tween.EASE_IN_OUT).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	var scale_x = %Title.scale.x
	var scale_y = %Title.scale.y
	tween_scale.tween_property(%Title, 'scale', Vector2(scale_x + 0.3, scale_y + 0.3), 4)
	tween_scale.tween_property(%Title, 'scale', Vector2(scale_x, scale_y), 4)
	
	var tween_mod := get_tree().create_tween().set_loops(-1).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_mod.tween_property(%Title, 'modulate', Color.YELLOW_GREEN, 2.5)
	tween_mod.tween_property(%Title, 'modulate', Color.ORANGE, 2.5)
	tween_mod.tween_property(%Title, 'modulate', Color.RED, 2.5)
	tween_mod.tween_property(%Title, 'modulate', Color.WHITE, 2)


func _resume_pressed():
	get_tree().paused = false
	hide()


func _start_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
