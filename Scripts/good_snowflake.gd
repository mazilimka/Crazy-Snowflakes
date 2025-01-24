extends Area2D

enum STATE { GOOD, BAD }

@onready var sprite: Sprite2D = $Sprite2D

var speed := randf_range(300, 500)
var current_state: STATE = STATE.GOOD:
	set(value):
		if current_state != value: 
			current_state = value
			update_snowfloke(current_state)

var time_to_transformation := randf_range(2, 6)
var is_can_transform: bool
var timer := 0.0
var direction = null

func _ready() -> void:
	body_entered.connect(player_entered)
	%VisibleOnScreenEnabler2D.screen_exited.connect(screen_exited)
	is_can_transform = -1 if randi() % 5 == 0 else 1
	update_snowfloke(current_state)


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= time_to_transformation and is_can_transform:
		current_state = STATE.BAD
	
	if not is_can_transform:
		good_snowflokes(delta)
		return
	
	match current_state:
		STATE.GOOD:
			good_snowflokes(delta)
		STATE.BAD:
			bad_snowflokes(delta)


func good_snowflokes(delta: float):
	position.y += speed * delta


func bad_snowflokes(delta: float):
	if direction == null:
		direction = global_position.direction_to(Global.Player.global_position)
	position += direction * speed * delta
	speed += 0.05


func update_snowfloke(state: STATE):
	match state:
		STATE.GOOD:
			sprite.modulate = Color.LIGHT_SKY_BLUE
			sprite.texture = load("res://assets_and_referens/showflaces1.png")
			#set_collision_layer_value(3, true)
			#set_collision_layer_value(4, false)
			set_collision_mask_value(1, false)
			speed = randf_range(30, 50)
		STATE.BAD:
			sprite.modulate = Color.RED
			#set_collision_layer_value(3, false)
			#set_collision_layer_value(4, true)
			set_collision_mask_value(1, true)
			speed = 600.0


func screen_exited():
	queue_free()


func player_entered(body: CharacterBody2D):
	if body == Global.Player:
		body.health -= 1
		queue_free()
		#if body.health == 0:
			#body.death()
