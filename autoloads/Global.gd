extends Node

var Player: CharacterBody2D = null
var Main: Node2D = null
var UI: CanvasLayer = null
var is_mobile: bool

func get_component(_node: Node, comp_name: String):
	return _node.get_node_or_null(comp_name)


func await_a_few_msec(number: float) -> bool:
	await get_tree().create_timer(number)
	return true
