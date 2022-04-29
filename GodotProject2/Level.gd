extends Node

export var treesmat:SpatialMaterial
export var floormat:SpatialMaterial

var sky:ProceduralSky

var booths : Array
var areaBooths : Dictionary 
var flames : Array
var Player:Node


export(Array,NodePath) var elevators:Array
export(Array,NodePath) var lights:Array
var _elevators:Array
var _lights:Array

export(Array,Texture) var tree_textures:Array=[]
export(Array,ShaderMaterial) var distance_materials:Array=[]

#land, air
var env_cols = {
	"alv_obstr":[0, Color("#c0db72"),Color("#ececec"), 40 , 10 , 12],#1
	"alv_v_ret":[1, Color("#45891a"),Color("#84c0db"), 40 , 10 , 12],#2
	"cor_affr":[2, Color("#ad9d33"),Color("#7aaddd"), 40, 10  , 12],#3
	"cor_fric":[3, Color("#64aadb"),Color("#64aadb"), 40, 10 , 12 ],#4
	"dors":[4, Color("#115e33"),Color("#4294be"), 40 , 10 , 12],#5
	"dors_glot_fric":[5, Color("#732930"),Color("#89c1da"), 40 , 10, 12 ],#6
	"dors_stops":[6, Color("#fab40b"),Color("#bceaff"), 40 , 10 , 12],#7
	"ejectives":[7, Color("#a3ce27"),Color("#31a2f2"), 40, 10 , 12 ],#8
	"epiglot":[8, Color("#524f40"),Color("#cbdae0"), 40 , 16, 18 ],#9
	"liquids":[9, Color("#40632b"),Color("#6eadda"), 40 , 10 , 12],#10
	"nasals":[10, Color("#f4b990"),Color("#b2dcef"), 40, 10 , 12 ],#11
	"pal":[11, Color("#bea5a5"),Color("#bea5a5"), 40 , 10 , 12],#12
	"plos_phonation":[12, Color("#524f40"),Color("#bea5a5"), 40, 10 , 12 ],#13
	"tones":[13, Color("#44891a"),Color("#dfdf59"), 40 , 10, 12 ],#14
	"vowel_phonation":[14, Color("#cccccc"),Color("#cccccc"), 40 , 10 , 12],#15
	"vowels":[15, Color("#ad9d33"),Color("#a7b4d3"), 40 , 15 , 17],#16
	"ant_lab_vel":[16, Color("#44891a"),Color("#86b4c9"), 40 , 15 , 16],#17
}


var zonetarget_pos:Vector3
var zonetarget_name:String=""

const zone_min_range_unzoomed:float=100.0
const zone_max_range_unzoomed:float=100.0
const sky_color_unzoomed:Color = Color("#3aa5be")
const ground_color_unzoomed:Color = Color("#395f79")


var target_max_range:float=100
var target_min_range:float=100
var target_sky_colour:Color=sky_color_unzoomed
var target_ground_colour:Color=ground_color_unzoomed
var target_tree_alpha:float=0

var cur_max_range:float=100
var cur_min_range:float=100
var cur_sky_color:Color=target_sky_colour
var cur_ground_color:Color=target_ground_colour
var cur_tree_alpha:float=0

var lerpspeed_range=2
var lerpspeed_colour=1
var lerpspeed_alpha=10

func setZone(n:String,pos:Vector3):		
	print("setZone")
	print(pos)
	print(n)
	
	var t_dat:Array = env_cols[n]
	var t_index:int=t_dat[0]
	var t_scale:float=t_dat[3]
	var t_range_min:float = t_dat[4]
	var t_range_max:float = t_dat[5]
	
	

	treesmat.albedo_texture = tree_textures[t_index]
	$world/VisionScene.call("setScale",t_scale)
	$world/VisionScene.visible=true
	$world/VisionScene.transform.origin = pos

	target_min_range=t_range_min
	target_max_range=t_range_max
	
	target_sky_colour=t_dat[2]
	target_ground_colour=t_dat[1]
	print("target ground color",target_ground_colour)
	print("target ground color",target_sky_colour)
	
	target_tree_alpha=1
	
	for mat in distance_materials:
		mat.set_shader_param("center",pos)
		
	
	for b in booths:
		if b.get_parent().name==n:
			b.call("showLabel")
		else:
			b.call("hideLabel")
			
	for f in flames:
		f.visible = f.get_parent().name==n

	
func unsetZone():
	
	for b in booths:
		b.call("showLabel")
		
	print("unsetZone")
	zonetarget_name=""
	target_min_range=zone_min_range_unzoomed
	target_max_range=zone_max_range_unzoomed
	target_sky_colour=sky_color_unzoomed
	target_ground_colour=ground_color_unzoomed
	target_tree_alpha=0
	#$world/VisionScene.visible=false
	
	
func _physics_process(delta):
	cur_min_range = lerp(cur_min_range,target_min_range,delta*lerpspeed_range)
	cur_max_range = lerp(cur_max_range,target_max_range,delta*lerpspeed_range)
	cur_tree_alpha = lerp(cur_tree_alpha,target_tree_alpha,delta*lerpspeed_alpha)
	cur_ground_color = cur_ground_color.linear_interpolate(target_ground_colour,delta*lerpspeed_colour)
	cur_sky_color = cur_sky_color.linear_interpolate(target_sky_colour,delta*lerpspeed_colour)
	sky.ground_bottom_color=cur_ground_color
	sky.ground_horizon_color=cur_ground_color
	sky.sky_horizon_color=cur_sky_color
	sky.sky_top_color=cur_sky_color
	
	treesmat.albedo_color=Color(1,1,1,cur_tree_alpha)
	floormat.albedo_color=Color(cur_ground_color.r,cur_ground_color.g,cur_ground_color.b,cur_tree_alpha)
	
	for mat in distance_materials:
		mat.set_shader_param("mindist",cur_min_range)
		mat.set_shader_param("maxdist",cur_max_range)


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
	var we:WorldEnvironment = $world/WorldEnvironment
	sky = we.environment.background_sky
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
	
	areaBooths = {}
	
	for b in booths:
		var areaName = b.get_parent().name
		areaBooths[areaName]=b
	
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
