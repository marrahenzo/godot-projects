extends Node2D

var selected_key: Variant
var selected_key_name = ""
var game_started = false
var game_ended = false
var inputs_per_second = 0.0
var is_mouse = false
var inputs = 0
var seconds = 0.0
var countdown = 3
@onready var game_timer = $GameTimer
@onready var start_timer = $StartTimer
@onready var countdown_timer = $CountdownTimer
@onready var info_label = $InfoLabel
@onready var key_label = $KeyLabel
@onready var score_text_label = $ScoreTextLabel
@onready var score_number_label = $ScoreNumberLabel
@onready var countdown_label = $CountdownLabel
@onready var background_score = $BackgroundScore

func _ready() -> void:
	score_text_label.hide()
	score_number_label.hide()
	countdown_label.hide()
	set_process(false)
	
func _input(event: InputEvent) -> void:
	if game_ended:
		pass
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
		is_mouse = event is InputEventMouseButton
		if not game_started:
			if (selected_key != null 
				and (!is_mouse and (selected_key == event.keycode)
				or is_mouse and (selected_key == event.button_index))
			):
				info_label.hide()
				key_label.hide()
				countdown_timer.start()
				countdown_label.show()
				game_started = true
			else:
				selected_key = event.button_index if is_mouse else event.keycode
				selected_key_name = event.as_text()
				key_label.text = "Selected key: " + selected_key_name
		else:
			if (selected_key != null 
				and (!is_mouse and (selected_key == event.keycode)
				or is_mouse and (selected_key == event.button_index))
			):
				inputs += 1
			
func start_game():
	countdown_label.hide()
	score_text_label.show()
	score_number_label.show()
	seconds = 0
	set_process(true)
	game_timer.start()
	
func _process(delta):
	seconds += delta
	inputs_per_second = inputs / seconds
	score_number_label.text = "%.2f" % inputs_per_second
	background_score.scale = Vector2(1, inputs_per_second * 5)

func _on_game_timer_timeout() -> void:
	set_process(false)
	game_ended = true

func _on_countdown_timer_timeout() -> void:
	if countdown > 1:
		countdown -= 1
		countdown_label.text = str(countdown)
		countdown_timer.start()
	else:
		countdown_timer.stop()
		start_game()
