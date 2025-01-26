extends PanelContainer


func _ready() -> void:
	if OS.has_feature("web"):
		%Quit.hide()
	%Sound.value_changed.connect(sound_changed)
	%Music.value_changed.connect(music_changed)
	%Resume.pressed.connect(_resume_pressed)
	%Quit.pressed.connect(_quit_pressed)
	%Sound.value = db_to_linear(Global.Player.broken_window_sound.volume_db)
	%Music.value = db_to_linear(Global.Player.music.volume_db)
	title_tween()


func open():
	get_tree().paused = true
	show()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		Global.is_mobile = true
	if Input.is_action_just_pressed("escape"):
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


func _set_bus_volume_db(bus_name: String, db: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(db))


func _quit_pressed():
	get_tree().quit()



func sound_changed(value: float):
	Global.Player.broken_window_sound.volume_db = linear_to_db(value)


func music_changed(value: float):
	Global.Player.music.volume_db = linear_to_db(value)
