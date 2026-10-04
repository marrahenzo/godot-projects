extends CharacterBody2D

@export var SPEED = 900
@export var PLAYER_NUMBER = 1

func _process(delta: float) -> void:
	velocity.y = 0
	if (Input.is_action_pressed("player1_up") && PLAYER_NUMBER == 1 
		|| Input.is_action_pressed("player2_up") && PLAYER_NUMBER != 1):
		velocity.y = -SPEED
		
	if (Input.is_action_pressed("player1_down") && PLAYER_NUMBER == 1 
		|| Input.is_action_pressed("player2_down") && PLAYER_NUMBER != 1):
		velocity.y = SPEED
	
	move_and_collide(velocity * delta)
