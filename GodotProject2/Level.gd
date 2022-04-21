extends Node

var booths : Array
var flames : Array
var Player:Node


export(Array,NodePath) var elevators:Array
export(Array,NodePath) var lights:Array
var _elevators:Array
var _lights:Array

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
		if !is_instance_valid(booth):
			solvedarray.append(true)	
		else:					
			solvedarray.append(booth.solved)
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(JSON.print(solvedarray))
	save_file.close()
		
func load_level():
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		return
		
	save_file.open("user://savegame.save", File.READ)
	print(save_file.get_as_text())
	var solved_data = JSON.parse(save_file.get_as_text()).result
	print("solved_data "+str(solved_data))
	save_file.close()
	
	for n in booths.size():
		if solved_data[n]:
			var booth = booths[n]	
			if !is_instance_valid(booth):
				continue
			booth.setsolved()
		
func setRegionVisibility():
	var solvedcount:int = 0
	for n in flames.size():
		var flame : AnimatedSprite3D  = flames[n]
		var groupname = flame.get_parent().name
		var solved = solvedgroup_by_name(groupname)

		
		if solved:
			flame.visible=false
			solvedcount=solvedcount + 1
		else:
			pass

		if solved:
			for m in booths.size():
				var booth:Node = booths[m]
				if !is_instance_valid(booth):
					continue
				if booth.group==groupname:
					booth.queue_free()
					
			for k in _elevators.size():
				var e : Spatial = _elevators[k]
				if is_instance_valid(e) and e.group==groupname:
					e.queue_free()
					
			for k in _lights.size():
				var e : Spatial = _lights[k]
				if is_instance_valid(e) and e.group==groupname:
					e.queue_free()
				
			if groupname=="MN":
				if is_instance_valid($Particles):
					$Particles.queue_free()
		
	if solvedcount==flames.size():
		$EndingPortal.visible=true
		$EndingPortal/EndBox/CollisionShape.disabled=false
		$EndingPortal/AudioStreamPlayer3D.play()
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Player = $Player
	_elevators=[]
	for ei in elevators.size():
		var en : NodePath = elevators[ei]
		var elevator = get_node(en)
		_elevators.append(elevator)
		
	_lights=[]
	for ei in lights.size():
		var en : NodePath = lights[ei]
		var light = get_node(en)
		_lights.append(light)
		
		
	booths=[]
	findByClass(self,"res://booth.gd",booths);
	flames=[]
	findByClass(self,"res://Flame.gd",flames);
	load_level()
	#find all area codes

	for n in flames.size():
		var flame:AnimatedSprite3D = flames[n] 
		var groupname = flame.get_parent().name


	setRegionVisibility()

	#enable/disable tongue bits

		

	
func solvedgroup_by_name(group:String):	
	var groupsolved=true
	for n in booths.size():	
		var booth = booths[n]
		if !is_instance_valid(booth):
			continue
		if booth.group==group:
			if not booth.solved:
				groupsolved=false
	return groupsolved
	

func solvedgroup(b:Node):
	var group:String = b.group
	var groupsolved=true
	for n in booths.size():
		var booth = booths[n]
		if !is_instance_valid(booth):
			continue
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
			if flame.get_parent().name==group:
				flame.visible=false
	save_level()
	setRegionVisibility()
	return groupsolved

func forceSolve(groupname):
	if solvedgroup_by_name(groupname):
		return
	for n in booths.size():
		var booth = booths[n]
		if !is_instance_valid(booth):
			continue
		if booth.group==groupname:
			var wassolved = solvedgroup(booth)
			booth.solved=true
			if not wassolved and solvedgroup(booth):
				onsolve(booth)
		
	
	
func _process(d):	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://titlescreen.tscn")
				
	if OS.is_debug_build():
		if Input.is_key_pressed(KEY_1):
			forceSolve('B')
		if Input.is_key_pressed(KEY_2):
			forceSolve('DG')
		if Input.is_key_pressed(KEY_3):
			forceSolve('GLOTTAL')
		if Input.is_key_pressed(KEY_4):
			forceSolve('FIXED')
		if Input.is_key_pressed(KEY_5):
			forceSolve('K')
		if Input.is_key_pressed(KEY_6):
			forceSolve('J')
		if Input.is_key_pressed(KEY_7):
			forceSolve('MN')
		if Input.is_key_pressed(KEY_8):
			forceSolve('RL_ROLLED')
		if Input.is_key_pressed(KEY_9):
			forceSolve('POP_H')
		if Input.is_key_pressed(KEY_0):
			forceSolve('SZ')
		if Input.is_key_pressed(KEY_INSERT):
			forceSolve('TH')
		if Input.is_key_pressed(KEY_HOME):
			forceSolve('VOWEL')
		if Input.is_key_pressed(KEY_PAGEUP):
			forceSolve('VW')
