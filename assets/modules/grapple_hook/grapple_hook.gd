extends KinematicBody2D
var player: Node

enum { HOOKED = 2, THROWN = 1, IDLE = 0 }
var state: int = IDLE

onready var hook = $Sprite
onready var rope = $Rope

var throw_length: float = 60
var length: float
var latched_length: float 
var speed := 4.5

var hooked: bool # If the Grappling Hook is currently locked onto something
var active: bool # If the Grappling Hook has been thrown and has no locked on yet
var at_end: bool # If the player is at the end of the rope

var velocity := Vector2.ZERO
var target := Vector2.ZERO
var dir:= 0

func _physics_process(delta):
	match state:
		HOOKED:
			pass
		THROWN:
			
			velocity = speed * to_local(target)
		IDLE:
			pass
	
	rope.region_rect = Rect2(0,0,4,length)
	move_and_slide(velocity)

func throw(pos: Vector2):
	if state == IDLE:
		target = pos
		dir = 1
		state = THROWN # Init State Change

func _disconnect_hook():
	target = Vector2.ZERO
	dir = 0
	state = IDLE

func _on_Area2D_body_entered(body):
	pass
