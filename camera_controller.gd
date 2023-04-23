extends Node2D

@onready var viewport_camera = $ViewportCamera
@onready var camera = $FullResCamera

func _ready():
	remove_child(viewport_camera)
	$"../SubViewportContainer/SubViewport/CharacterBody2D".add_child(viewport_camera)

func _physics_process(_delta):
	var offset_x = fmod(viewport_camera.get_screen_center_position().x, 1.0)
	var offset_y = fmod(viewport_camera.get_screen_center_position().y, 1.0)
	camera.offset = Vector2(offset_x, offset_y)
	
	# CAMERA PANNING
	var mouse_position = get_global_mouse_position()
	
	var y = mouse_position.y
	var x = mouse_position.x
	
	# these are guesstimated
	var topleft = Vector2(600, 300)
	var bottomright = Vector2(1300, 800)
		
	if y < topleft.y or y > bottomright.y or x < topleft.x or x > bottomright.x: # camera is off-centered
		@warning_ignore("integer_division")
		move_to(mouse_position - Vector2(1920/2, 1080/2), 0.02) # should get screen size for correctness
	else:
		move_to(Vector2(0, 0.0), 0.07)

func move_to(goal: Vector2, weight: float):
	if abs(goal.x) > 250*(1/camera.zoom.x):
		goal.x = (goal.x/abs(goal.x)) * 250*(1/camera.zoom.x)
	if abs(goal.y) > 250*(1/camera.zoom.y):
		goal.y = (goal.y/abs(goal.y)) * 250*(1/camera.zoom.y)
	var pos = lerp(viewport_camera.position, goal, weight)
	viewport_camera.position = pos
	
