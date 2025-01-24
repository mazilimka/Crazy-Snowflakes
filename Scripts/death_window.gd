extends PanelContainer

func _ready() -> void:
	%Restart.pressed.connect(_restart_pressed)
	%Quit.pressed.connect(_quit_pressed)


func _restart_pressed():
	hide()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _quit_pressed():
	get_tree().quit()
