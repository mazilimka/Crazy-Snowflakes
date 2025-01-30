extends Node

var Player: CharacterBody2D = null
var Main: Node2D = null
var UI: CanvasLayer = null
var is_mobile: bool
var is_endless_mode := false
var counter_of_snowflakes := 0


func get_component(_node: Node, comp_name: String):
	return _node.get_node_or_null(comp_name)


func await_a_few_msec(number: float) -> bool:
	await get_tree().create_timer(number)
	return true


func get_lvl() -> Node2D:
	return get_tree().current_scene


func global_restart():
	counter_of_snowflakes = 0
	Snowflakes.set_def_difficulty()
	Main.set_def_defficulty()
	get_tree().reload_current_scene()
	get_tree().paused = false
