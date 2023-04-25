extends Node2D

@onready var viewport_camera = $ViewportCamera
@onready var camera = $FullResCamera
@onready var viewport_size = get_viewport().get_visible_rect().size
@onready var width = viewport_size.x
@onready var height = viewport_size.y
var panning_border_thickness = 50

func _ready():
	remove_child(viewport_camera)
	$"../SubViewportContainer/SubViewport/CharacterBody2D".add_child(viewport_camera)

func _process(delta):
	var offset_x = fmod(viewport_camera.get_screen_center_position().x, 1.0)
	var offset_y = fmod(viewport_camera.get_screen_center_position().y, 1.0)
	camera.offset = Vector2(offset_x, offset_y)

	var mouse_position = get_global_mouse_position()
	var y = mouse_position.y
	var x = mouse_position.x
	
	# panning limits
	var topleft = Vector2(width/camera.zoom.x * (camera.zoom.x/2 - 0.5) + panning_border_thickness, height/camera.zoom.x * (camera.zoom.x/2 - 0.5) + panning_border_thickness)
	var bottomright = Vector2(width/camera.zoom.x * (camera.zoom.x/2 + 0.5) - panning_border_thickness, height/camera.zoom.x * (camera.zoom.x/2 + 0.5) - panning_border_thickness)
		
	if y < topleft.y or y > bottomright.y or x < topleft.x or x > bottomright.x:
		@warning_ignore("integer_division")
		move_to(mouse_position - Vector2(width/2, height/2), 0.02)
	else:
		move_to(Vector2(0, 0.0), 0.07)

func move_to(goal: Vector2, weight: float):
	if abs(goal.x) > 250*(1/camera.zoom.x):
		goal.x = (goal.x/abs(goal.x)) * 250*(1/camera.zoom.x)
	if abs(goal.y) > 250*(1/camera.zoom.y):
		goal.y = (goal.y/abs(goal.y)) * 250*(1/camera.zoom.y)
	var pos = lerp(viewport_camera.position, goal, weight)
	viewport_camera.position = pos
	
