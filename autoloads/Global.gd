extends Node

var Player: CharacterBody2D = null
var Main: Node2D = null
var UI: CanvasLayer = null
var is_mobile: bool
var is_endless_mode := false
var counter_of_snowflakes := 0


func get_component(_node: Node, comp_name: String):
	return _node.get_node_or_null(comp_name)


func await_a_few_msec(number: float) -> void:
	var timer = get_tree().create_timer(number)
	await timer.timeout


func set_input_as_handled():
	get_viewport().set_input_as_handled()


func get_lvl() -> Node2D:
	return get_tree().current_scene


func global_restart():
	counter_of_snowflakes = 0
	Snowflakes.set_def_difficulty()
	Main.set_def_difficulty()
	get_tree().reload_current_scene()
	get_tree().paused = false
