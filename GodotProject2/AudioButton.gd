extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var num = 0

var root_parent:Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	root_parent = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	
var looping=false
func interact():

	root_parent.on_pressed(num)
	
	print("interact")
	if looping:
		return
	
	looping=true

	var parent : MeshInstance = self.get_parent() as MeshInstance
	var oldpos = parent.translation
	
	parent.translate_object_local(-Vector3.UP*0.035)

	yield(get_tree().create_timer(0.2), "timeout")
	parent.translation = oldpos
	looping=false
