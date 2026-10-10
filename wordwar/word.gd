extends Node2D
class_name Word

signal word_completed

@onready var text = $text
@onready var collision = $collision
@export var word: String = ""
@export var base_speed = 100
var speed_modifier = 1
var letters: PackedStringArray
var next_letter = ""
var next_letter_index = 0
var screen_size: Rect2
const MIN_FONT_SIZE = 16
const MAX_FONT_SIZE = 40
const COLOR_NORMAL = Color.WHITE
const COLOR_COMPLETED = Color.DEEP_SKY_BLUE

func _ready() -> void:
	word = Words.WORDS.pick_random()
	speed_modifier = randf_range(0.75, 1.1)
	text.add_theme_font_size_override("normal_font_size", randi_range(MIN_FONT_SIZE, MAX_FONT_SIZE))
	screen_size = get_viewport_rect()
	position.y = randf_range(35, screen_size.size.y - 25)
	position.x = screen_size.size.x + 5
	collision.position.x = position.x + text.get_line_width(0) + 10
	letters = word.split("")
	if letters.size() > 0:
		next_letter = letters.get(next_letter_index)
	else:
		set_process_input(false)
	update_color(0)
	
func _input(event: InputEvent) -> void:
	if(event.is_pressed()):
		if(next_letter == event.as_text().to_lower()):
			if(next_letter_index == letters.size() - 1):
				complete()
				return
			next_letter_index += 1
		else:
			next_letter_index = 0
		next_letter = letters.get(next_letter_index)
		update_color(next_letter_index)
	
func _process(delta: float) -> void:
	position.x -= base_speed * speed_modifier * delta
	collision.position.x = position.x + text.get_line_width(0) + 25
	
func update_color(matched_count: int) -> void:
	var matched := word.substr(0, matched_count)
	var remaining := word.substr(matched_count)
	$text.text = "[color=#%s]%s[/color][color=#%s]%s[/color]" % [
		COLOR_COMPLETED.to_html(false), matched,
		COLOR_NORMAL, remaining
	]
	
func reset():
	next_letter_index = 0
	next_letter = letters.get(next_letter_index)
	update_color(next_letter_index)
	
func complete():
	word_completed.emit()
	queue_free()
