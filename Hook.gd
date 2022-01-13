extends KinematicBody2D

var player := KinematicBody2D
var target := Vector2.ZERO

var speed := 200
var max_dist := 20
var latched_dist : float
var dist : float # Should equal `player.position.distance_to(target)`
var dir : Vector2

var retreating : bool
var hooked : bool

var player_bounds := CircleShape2D.new()

func _ready():
	dir = to_local(target).normalized()

func _physics_process(delta):
	$PlayerBounds/Bounds.shape = player_bounds
	player_bounds.radius = latched_dist
	
	if dist >= max_dist: retreating = true
	
	$Sprite.look_at(player.position)
	$Sprite.rotation_degrees -= 180
	
	if !hooked and dist <= max_dist and !retreating:
		dist += 1
		var vel := Vector2.ZERO
		vel = dir * speed
		
		move_and_slide(vel, Vector2.UP)
	elif dist <= max_dist and retreating:
		var vel := Vector2.ZERO
		vel = to_local(player.position).normalized() * speed*2
		
		move_and_slide(vel, Vector2.UP)
	elif hooked:
		pass


func _on_Collider_body_entered(body):
	if body.is_in_group("player") : return
	if retreating: return
	print("Hooked On")
	hooked = true
	latched_dist = player.position.distance_to(position)

func _on_RetreatingCollider_body_entered(body):
	if body.is_in_group("player") and retreating and !hooked:
		queue_free()

