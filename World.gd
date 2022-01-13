extends Node2D

func _physics_process(delta):
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused == false: 
			for c in get_children():
				c.get_tree().paused = true
		else:
			for c in get_children():
				c.get_tree().paused = false
