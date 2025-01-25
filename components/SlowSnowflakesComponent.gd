extends Node
class_name SlowSnowflakesComponent

var sec := 0.0
var timer := 3.0
var snowfloake: Area2D

#signal slow_snowflakes(toggled_on: bool)
func _ready() -> void:
	snowfloake = get_parent()
	set_slow_state()


func _process(delta: float) -> void:
	sec += delta
	if sec >= timer:
		#slow_snowflakes.emit(false)
		set_prev_state()
		Global.UI.progress_before_slowing = 3
		queue_free()


func set_slow_state():
	snowfloake.previous_state = snowfloake.current_state
	snowfloake.current_state = snowfloake.STATE.SLOW
	snowfloake.is_slower = true 


func set_prev_state():
	snowfloake.is_slower = false
	snowfloake.was_slow = true
	snowfloake.current_state = snowfloake.previous_state
	
