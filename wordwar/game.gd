extends Node2D

@onready var spawn_timer = $WordSpawnTimer
@onready var game_timer = $GameTimer
@onready var speed_increase_timer = $SpeedIncreaseTimer
@onready var time_label = $TimeLabel
@onready var score_label = $ScoreLabel
@onready var game_over_label = $GameOverLabel
@onready var pop_sound = $Pop
const WORD = preload("res://word.tscn")
const WORD_GROUP = "words"
var sound_pitch_scale: float = 1.0
var word_speed_increase = 0
var score = 0
var total_seconds = 0

func _ready() -> void:
	spawn_timer.start()
	speed_increase_timer.start()
	game_timer.start()

func _on_word_spawn_timer_timeout() -> void:
	spawn_word()

func _on_game_timer_timeout() -> void:
	total_seconds += 1
	var minutes = 0
	if(total_seconds > 59):
		minutes = floor(total_seconds / 60.0)
	var seconds = total_seconds - minutes * 60
	time_label.text = "Time: " + "%01d" % minutes + ":" + "%02d" % seconds

func spawn_word():
	var word: Word = WORD.instantiate()
	word.base_speed = word.base_speed + word_speed_increase
	word.word_completed.connect(_on_word_completed)
	word.add_to_group(WORD_GROUP)
	add_child(word)

func _on_word_completed():
	get_tree().call_group(WORD_GROUP, "reset")
	score += 1
	score_label.text = "Score: " + str(score)
	pop_sound.pitch_scale = randf_range(0.5, 1.5)
	pop_sound.play()

func _on_speed_increase_timer_timeout() -> void:
	word_speed_increase += 10

func _on_lose_area_area_entered(_area: Area2D) -> void:
	get_tree().call_group(WORD_GROUP, "queue_free")
	spawn_timer.stop()
	game_timer.stop()
	game_over_label.show()
