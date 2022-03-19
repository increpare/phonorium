extends Node

var booths : Array
var flames : Array
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func findByClass(node: Node, classPath : String, result : Array) -> void:
	var script : Reference = node.get_script()
	if script!=null:
		var scriptPath = script.get_path()
		if scriptPath==classPath:
			result.push_back(node)
	for child in node.get_children():
		findByClass(child, classPath, result)


# Called when the node enters the scene tree for the first time.
func _ready():
	booths=[]
	findByClass(self,"res://booth.gd",booths);
	flames=[]
	findByClass(self,"res://Flame.gd",flames);

func solvedgroup(b:Node):
	var group:String = b.group
	var groupsolved=true
	for n in booths.size():
		var booth = booths[n]
		if booth.group==group:
			if not booth.solved:
				groupsolved=false
	return groupsolved

func onsolve(b:Node):
	#check if any
	var group:String = b.group
	var groupsolved=solvedgroup(b)
	if groupsolved:
		for n in flames.size():
			var flame : AnimatedSprite3D = flames[n] as AnimatedSprite3D	
			print(flame.GroupName)
			if flame.GroupName==group:
				flame.visible=false
	return groupsolved
