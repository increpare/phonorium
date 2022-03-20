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

func save_level():	
	var solvedarray = []
	for n in booths.size():
		var booth = booths[n]
		solvedarray.append(booth.solved)
	var save_file = File.new()
	save_file.open("user://blag.save", File.WRITE)
	save_file.store_line(JSON.print(solvedarray))
	save_file.close()
		
func load_level():
	var save_file = File.new()
	if not save_file.file_exists("user://blag.save"):
		return
		
	save_file.open("user://blag.save", File.READ)
	print(save_file.get_as_text())
	print( "{solved:"+save_file.get_as_text()+"}")
	var solved_data = JSON.parse("{solved:"+save_file.get_as_text()+"}").solved
	save_file.close()
	
	for n in booths.size():
		if solved_data[n]:
			var booth = booths[n]	
			booth.setsolved()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	booths=[]
	findByClass(self,"res://booth.gd",booths);
	flames=[]
	findByClass(self,"res://Flame.gd",flames);
	#load_level()

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
	#save_level()
	return groupsolved

func _process(d):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
