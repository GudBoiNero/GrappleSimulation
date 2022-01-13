extends Node2D

export(Array, String) var modules

func _ready():
	pass # not working
	
#	for i in modules:
#		var test = load(modules[i])
#		if is_instance_valid(test):
#			var c = load(modules[i]).instance()
#			add_child(c)
#		else:
#			push_warning(str(modules[i])+" is not a Module")
