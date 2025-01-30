extends PanelContainer

func _ready() -> void:
	if OS.has_feature("web"):
		%Quit.hide()
	%Restart.pressed.connect(_restart_pressed)
	%Quit.pressed.connect(_quit_pressed)
	%EndlessMode.pressed.connect(_endless_mode_pressed)


func _endless_mode_pressed():
	Global.is_endless_mode = true
	Global.global_restart()
	hide()


func _restart_pressed():
	Global.global_restart()
	hide()


func _quit_pressed():
	get_tree().quit()
