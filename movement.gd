extends CharacterBody2D

var SPEED = 120

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized() # no normalize for faster side
	
	velocity = input_vector * SPEED
	move_and_slide()
