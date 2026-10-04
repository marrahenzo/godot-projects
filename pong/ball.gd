extends CharacterBody2D

signal score(side: String)

@export var SPEED = 500
@export var MAX_SPEED = SPEED * 1.5
@export var MIN_SPEED = SPEED * 0.8
var speed_modifier = 1
@onready var bounce_sound = $BounceSound
@onready var score_sound = $ScoreSound
@onready var timer = $StartTimer
var SCREEN_SIZE: Vector2

func _ready() -> void:
	SCREEN_SIZE = get_viewport_rect().size
	set_velocity(serve_velocity(1 if randf() < 0.5 else -1))

func serve_velocity(dir_x: int) -> Vector2:
	return Vector2(dir_x * SPEED, randi_range(-500, 500))

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider != null:
			if collider.is_in_group("score_walls"):
				score.emit(collider.name)
				score_sound.play()
				position = SCREEN_SIZE / 2
				set_velocity(serve_velocity(-1 if collider.name == "LeftWall" else 1))
				timer.start(1)
				set_physics_process(false)
			else:
				speed_modifier = randf_range(MIN_SPEED, MAX_SPEED)
				velocity = velocity.bounce(collision_info.get_normal()) * speed_modifier
				velocity = velocity.normalized() * clampf(velocity.length(), MIN_SPEED, MAX_SPEED)
				bounce_sound.play()

func _on_start_timer_timeout() -> void:
	set_physics_process(true)
