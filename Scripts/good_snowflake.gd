extends Area2D

enum STATE { GOOD, TRANSFORMATION, BAD, SLOW }

@onready var sprite: Sprite2D = $Sprite2D

var was_slow := false
var is_slower := false
var speeds := {
	"good": randf_range(30, 50),
	"bad": 600.0,
	"slow": 20.0
}
var previous_speed := 0.0
var speed := 0.0
var previous_state: STATE
var current_state: STATE = STATE.GOOD:
	set(value):
		if current_state != value: 
			current_state = value
			update_snowfloke(current_state)

var time_to_transformation := randf_range(2, 6)
var is_can_transform: bool
var timer := 0.0
var direction

func _ready() -> void:
	body_entered.connect(player_entered)
	%VisibleOnScreenEnabler2D.screen_exited.connect(screen_exited)
	is_can_transform = -1 if randi() % 5 == 0 else 1
	update_snowfloke(current_state)


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= time_to_transformation and is_can_transform:
		if is_slower:
			previous_state = STATE.TRANSFORMATION
			transform_tween()
		else:
			current_state = STATE.TRANSFORMATION
		timer = 0
	
	if not is_can_transform:
		good_snowflokes(delta)
		return
	
	match current_state:
		STATE.GOOD:
			good_snowflokes(delta)
		STATE.BAD:
			bad_snowflokes(delta)
		STATE.SLOW:
			global_position.y += speed * delta
		STATE.TRANSFORMATION:
			good_snowflokes(delta)


func good_snowflokes(delta: float):
	global_position.y += speed * delta


func bad_snowflokes(delta: float):
	if direction == null:
		direction = global_position.direction_to(Global.Player.global_position)
	global_position += direction * speed * delta
	speed += 0.05


func update_snowfloke(state: STATE):
	match state:
		STATE.GOOD:
			sprite.modulate = Color.LIGHT_SKY_BLUE
			#sprite.texture = load("res://assets_and_referens/showflaces1.png")
			set_collision_mask_value(1, false)
			speed = speeds["good"]
		STATE.TRANSFORMATION:
			if not was_slow:
				transform_tween()
			else:
				var tween: Tween = get_tree().create_tween()
				tween.tween_property(sprite, "scale", Vector2(1.8, 1.8), 0.15)
				await tween.finished
				current_state = STATE.BAD
		STATE.BAD:
			sprite.modulate = Color.RED
			set_collision_mask_value(1, true)
			speed = speeds["bad"]
		STATE.SLOW:
			speed = speeds["slow"]
			set_collision_mask_value(1, true)


func transform_tween():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color.BLACK, 0.2)
	tween.parallel().tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.tween_property(sprite, "scale", Vector2(1.8, 1.8), 0.15)
	await tween.finished
	if not is_slower:
		current_state = STATE.BAD


func screen_exited():
	queue_free()


func player_entered(body: CharacterBody2D):
	if body == Global.Player:
		if not body.is_save_mode:
			body.health -= 1
			body.taked_damage()
		queue_free()


func launch_slow_comp():
	if is_slower:
		return
	var slow_snowflakes_comp := SlowSnowflakesComponent.new()
	add_child(slow_snowflakes_comp)
