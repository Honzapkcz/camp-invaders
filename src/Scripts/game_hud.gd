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

@onready var _base_default_position : Vector2 = $JoistickButton.position
@onready var _tip_default_position : Vector2 = $JoistickButton/Tip.position

# FUNCTIONS

func _ready():
	if not DisplayServer.is_touchscreen_available():
		hide()

func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed and $JoistickButton/Tip.pressed and _touch_index == -1:
			_touch_index = event.index
			_update_joystick(event.position)
		elif event.index == _touch_index:
			# Reset on release
			is_pressed = false
			output = Vector2.ZERO
			_touch_index = -1
			$JoistickButton.position = _base_default_position
			$JoistickButton/Tip.position = _tip_default_position
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_joystick(event.position)
	else: return
	get_viewport().set_input_as_handled()

func _update_joystick(touch_position: Vector2):
	var center : Vector2 = $JoistickButton.global_position # + Vector2(30, 30)
	var vector : Vector2 = touch_position - center
	vector = vector.limit_length(clampzone_size)
	
	$JoistickButton/Tip.global_position = vector + center - $JoistickButton/Tip.pivot_offset
	
	if vector.length_squared() > deadzone_size * deadzone_size:
		is_pressed = true
		output = (vector - (vector.normalized() * deadzone_size)) / (clampzone_size - deadzone_size)
	else:
		is_pressed = false
		output = Vector2.ZERO

