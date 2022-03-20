extends Node

var booths : Array
var flames : Array

var splits_names:Array
var splits_tongue:Array
var splits_orig:Array

export(Array,NodePath) var elevators:Array
var _elevators:Array

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
			continue
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
			if !is_instance_valid(booth):
				continue
			booth.setsolved()
		
func setRegionVisibility():
	var solvedcount:int = 0
	for n in flames.size():
		var flame = flames[n]
		var groupname = flame.GroupName
		var solved = solvedgroup_by_name(groupname)
		
		var target_to_enable:MeshInstance
		var target_to_disable:MeshInstance
		
		if solved:
			solvedcount=solvedcount + 1
			target_to_disable = splits_orig[n]
			target_to_enable = splits_tongue[n]
		else:
			target_to_enable = splits_orig[n]
			target_to_disable = splits_tongue[n]
			
		target_to_disable.visible = false
		target_to_enable.visible = true
		
		var collider_to_enable:StaticBody = target_to_enable.find_node("StaticBody")
		var collider_to_disable:StaticBody = target_to_disable.find_node("StaticBody")
		
		collider_to_enable.get_child(0).disabled=false
		collider_to_disable.get_child(0).disabled=true
		
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
				
			if groupname=="MN":
				if is_instance_valid($Particles):
					$Particles.queue_free()
	
	# if POP_H solved but VOWEL unsolved, show ladder
	var showladder=false
	if solvedgroup_by_name("POP_H") and not solvedgroup_by_name("VOWEL"):
		showladder=true
		
	$pop_h_ladder/Cube.visible=showladder
	$pop_h_ladder/Cube/StaticBody/CollisionShape.disabled=not showladder
	
	#set head position
	var minprogress = 0.0
	var maxprogress = 13.0
	var curprogress = solvedcount
	var progress = curprogress/maxprogress
	print("progress: " +str(progress))
	if progress<0.5:
		progress*=2
		var t = $worldmaphead.translation
		var r = $worldmaphead/TopHead.rotation_degrees
		t.y=-42.729+(0.309+42.729)*progress
		r.z = -180
		$worldmaphead.translation=t
		$worldmaphead/TopHead.rotation_degrees=r
	else:
		progress=(progress-0.5)*2
		var t = $worldmaphead.translation
		var r = $worldmaphead/TopHead.rotation_degrees
		t.y=0.309
		r.z = -180+180*progress
		$worldmaphead.translation=t
		$worldmaphead/TopHead.rotation_degrees=r
		
	print($worldmaphead.translation)
	print($worldmaphead/TopHead.rotation_degrees)
		
	print("progress "+str(progress))
	if solvedcount==13:
		$EndingPortal.visible=true
		$EndingPortal/EndBox/CollisionShape.disabled=false
		$EndingPortal/AudioStreamPlayer3D.play()
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_elevators=[]
	for ei in elevators.size():
		var en : NodePath = elevators[ei]
		var elevator = get_node(en)
		_elevators.append(elevator)
		
	booths=[]
	findByClass(self,"res://booth.gd",booths);
	flames=[]
	findByClass(self,"res://Flame.gd",flames);
	#load_level()
	#find all area codes
	splits_names=[]
	splits_tongue=[]
	splits_orig=[]
	
	for n in flames.size():
		var flame:AnimatedSprite3D = flames[n] 
		var groupname = flame.GroupName
		splits_names.append(groupname)
		print("adding "+groupname)
		#for each groupname, add slipts_orig and splits_tongue to list
		var orig = $splits.find_node("worldmap"+groupname)
		splits_orig.append(orig)
		var tongue = $splits_tongue.find_node("worldmap"+groupname)
		splits_tongue.append(tongue)
		
		print(orig)
		print(tongue)
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
			print(flame.GroupName)
	#save_level()
			if flame.GroupName==group:
				flame.visible=false
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
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		
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
