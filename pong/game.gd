extends Node2D

var player_1_score = 0
var player_2_score = 0
@onready var LABEL_PLAYER_1_SCORE = $Player1Score
@onready var LABEL_PLAYER_2_SCORE = $Player2Score

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_ball_score(side: String) -> void:
	if side == "LeftWall":
		player_1_score += 1
		LABEL_PLAYER_1_SCORE.text = str(player_1_score)
	else:
		player_2_score += 1
		LABEL_PLAYER_2_SCORE.text = str(player_2_score)
