extends KinematicBody2D

# Player Variables
export var speed: float = 40
export var max_speed: float = 130
export var friction: float = 0.6

export var gravity: float = 86
export var max_gravity: float = 100
export var air_friction: float = 0.03

export var grapple_speed: float = 40
export var grapple_deadzone := Vector2(-40, 40)

var velocity := Vector2.ZERO

# Grapple Variables
onready var grapple_hook_inst = preload("res://GrappleHook.tscn")

func _physics_process(delta):
	var dir = -int(Input.is_action_pressed("ui_left"))+int(Input.is_action_pressed("ui_right"))
	var grounded: bool = is_on_floor()

	if grounded:
		velocity.x = lerp(velocity.x, dir*speed, friction)
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.y = 0
	else:
		velocity.x = lerp(velocity.x, dir*speed, air_friction)
		velocity.y = lerp(velocity.y, gravity, air_friction)

	if Input.is_action_just_pressed("space") and grounded:
		velocity.y -= 150

	print(velocity)
	move_and_slide(velocity,Vector2.UP)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			var temp_pos = event.position # Temp Var
			_grapple(global_position, temp_pos)

func _grapple(current_pos, pos):
	print(current_pos, pos)
