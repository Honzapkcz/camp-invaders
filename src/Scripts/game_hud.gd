extends Control

## A simple virtual joystick for touchscreens, with useful options.
## Github: https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot

# EXPORTED VARIABLE

## If the input is inside this range, the output is zero.
@export_range(0, 200, 1) var deadzone_size : float = 10

## The max distance the tip can reach.
@export_range(0, 500, 1) var clampzone_size : float = 75

# PUBLIC VARIABLES

## If the joystick is receiving inputs.
var is_pressed := false

# The joystick output.
var output := Vector2.ZERO

# PRIVATE VARIABLES

var _touch_index : int = -1

@onready var _base_radius = $JoistickButton.size * $JoistickButton.get_global_transform_with_canvas().get_scale() / 2

@onready var _base_default_position : Vector2 = $JoistickButton.position
@onready var _tip_default_position : Vector2 = $JoistickButton/Tip.position

# FUNCTIONS

func _ready():
	if not DisplayServer.is_touchscreen_available():
		hide()

func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_joystick_area(event.position) and _touch_index == -1:
				_move_base(event.position)
				_touch_index = event.index
				_update_joystick(event.position)
		elif event.index == _touch_index:
			# Reset
			is_pressed = false
			output = Vector2.ZERO
			_touch_index = -1
			$JoistickButton.position = _base_default_position
			$JoistickButton/Tip.position = _tip_default_position
			
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_joystick(event.position)
	else: return
	get_viewport().set_input_as_handled()

func _move_base(new_position: Vector2):
	$JoistickButton.global_position = new_position - $JoistickButton.pivot_offset * get_global_transform_with_canvas().get_scale()

func _move_tip(new_position: Vector2):
	$JoistickButton/Tip.global_position = new_position - $JoistickButton/Tip.pivot_offset * $JoistickButton.get_global_transform_with_canvas().get_scale()

func _is_point_inside_joystick_area(point: Vector2):
	return point >= global_position and point <= global_position + (size * get_global_transform_with_canvas().get_scale())

func _is_point_inside_base(point: Vector2):
	var center : Vector2 = $JoistickButton.global_position + _base_radius
	var vector : Vector2 = point - center
	if vector.length_squared() <= _base_radius.x * _base_radius.x:
		return true
	else:
		return false

func _update_joystick(touch_position: Vector2):
	var center : Vector2 = $JoistickButton.global_position + _base_radius
	var vector : Vector2 = touch_position - center
	vector = vector.limit_length(clampzone_size)
	
	_move_tip(center + vector)
	
	if vector.length_squared() > deadzone_size * deadzone_size:
		is_pressed = true
		output = (vector - (vector.normalized() * deadzone_size)) / (clampzone_size - deadzone_size)
	else:
		is_pressed = false
		output = Vector2.ZERO

