extends PanelContainer

func _ready() -> void:
	if OS.has_feature("web"):
		%Quit.hide()
	%Restart.pressed.connect(_restart_pressed)
	%Quit.pressed.connect(_quit_pressed)


func end_score_tween():
	var tween := get_tree().create_tween().set_loops(-1).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(%EndScore, "visible", false, 0.4)
	tween.tween_property(%EndScore, "visible", true, 0.4)


func open():
	show()
	Global.counter_of_snowflakes = 0
	if Global.is_endless_mode:
		end_score_tween()
		%EndScore.show()
		var parts : Array = Global.UI.score.text.split(' ', true)
		%EndScore.text = "Your Score: " + parts[1]


func _restart_pressed():
	Global.global_restart()
	hide()


func _quit_pressed():
	get_tree().quit()
