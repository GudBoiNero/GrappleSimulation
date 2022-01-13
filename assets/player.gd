extends KinematicBody2D


# Utils
enum { LEFT = -1, NONE = 0, RIGHT = 1, TOP = 2, BOTH = 10 }

# Player Variables
export var speed: float = 40
export var max_speed: float = 130
export var friction: float = 0.6

export var gravity: float = 43
export var max_gravity: float = 100
export var air_friction: float = 0.07

export var grapple_speed: float = 40
export var grapple_deadzone := Vector2(-40, 40)

var velocity := Vector2.ZERO

# Grapple Variables
var current_hook : Node
onready var grapple_hook_inst = preload("res://Hook.tscn")

func _physics_process(delta):
	var dir = -int(Input.is_action_pressed("ui_left"))+int(Input.is_action_pressed("ui_right"))
	var grounded: bool = _grounded()

	if grounded:
		velocity.x = lerp(velocity.x, dir*speed, friction)
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.y = 0
	else:
		velocity.x = lerp(velocity.x, dir*speed, air_friction)
		velocity.y = lerp(velocity.y, gravity, air_friction)

	if Input.is_action_just_pressed("space") and grounded:
		velocity.y -= 150

	match _get_wall():
		BOTH:
			velocity.x = lerp(velocity.x, 0, 0.8)
		LEFT:
			velocity.x = clamp(velocity.x, 0, max_speed)
		RIGHT:
			velocity.x = clamp(velocity.x, -max_speed, 0)
		TOP:
			velocity.y = 10
		NONE:
			pass
	
	if is_instance_valid(current_hook):
		
		$RopeLine.points[1] = to_local(current_hook.position)
		
		if not current_hook.get("player_pos") == null:
			current_hook.player_pos = position
	else:
		$RopeLine.points[1] = Vector2.ZERO
	
	
	move_and_slide(velocity,Vector2.UP)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			
			var temp_pos = event.position # Temp Var
			
			_grapple(global_position, temp_pos)

func _grapple(current_pos, pos):
	if is_instance_valid(current_hook):
		if current_hook != null: current_hook.queue_free()
	
	var hook = grapple_hook_inst.instance()
	
	hook.target = pos 
	hook.position = position
	hook.hooked = false
	hook.player = self
	current_hook = hook
	
	get_parent().add_child(hook)

func _grounded() -> bool:
	for g in $Grounded.get_children():
		if g.is_colliding():
			return true
	
	return false

func _get_wall() -> int:
	if $Bounds/LeftCast.is_colliding() and $Bounds/RightCast.is_colliding():
		return BOTH
	elif $Bounds/LeftCast.is_colliding():
		return LEFT
	elif $Bounds/RightCast.is_colliding():
		return RIGHT
	elif $Bounds/TopCast.is_colliding():
		return TOP
	else:
		return NONE

func _on_wall() -> bool:
	return $Bounds/LeftCast.is_colliding() or $Bounds/RightCast.is_colliding() or $Bounds/RightCast.is_colliding() and $Bounds/LeftCast.is_colliding()
