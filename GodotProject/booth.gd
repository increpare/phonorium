extends Spatial

export(Array, int) var Solution : Array = [ 1,0,1,1,0 ]
export(Array, AudioStream) var Audio : Array = []
export var equally_spaced:bool = true

var light_off = preload("res://models/Lampe_off.material")
var light_on = preload("res://models/Lampe_on.material")
var light_red = preload("res://models/Lampe_red.material")
var light_green = preload("res://models/Lampe_green.material")
	
var jingle_lose = preload("res://audio/booth_fail_short.wav")
var jingle_solve = preload("res://audio/booth_solve.wav")
var jingle_solve_area = preload("res://audio/booth_solve_area_big.wav")


var lights : Array = []

var lightmats : Array = []
	
var inputarray:Array=[]
var spacing:float=-1

var level;

var group:String
var solved:bool

func setsolved():
	solved=true
	for n in lights.size():		
		set_light(n,3)
		
var timestamp

# Called when the node enters the scene tree for the first time.
func _ready():
	timestamp=0
	solved=false
	group = get_parent().name
	level = self.get_parent().get_parent().get_parent()
	
	var solutionLength = 5;
	randomize()
	#if randi()%2==0:
#		solutionLength=4
	match Audio.size():
		2:
			solutionLength=7
			if randi()%2==0:
				solutionLength=6
		3:
			solutionLength=6
			if randi()%2==0:
				solutionLength=5
			
	Solution=[]
	for i in solutionLength:
		var r = randi()%Audio.size()
		Solution.append(r)
		
	#force to include one of each
	for i in Audio.size():
		var found=false
		var frequency=[0,0,0,0,0,0,0]
		var example_pos=[0,0,0,0,0,0,0]
		for idx in Solution.size():
			var n = Solution[idx] 
			frequency[n]=frequency[n]+1
			example_pos[n]=idx
		if frequency[i]==0:
			for idx in Audio.size():
				if frequency[idx]>1:
					var target_pos = example_pos[idx]
					Solution[target_pos]=i
					frequency[idx] = frequency[idx]-1
					break
					
	#if you get four in a row the same, swap out the middle one with something else
	for i in (Solution.size()-3):
		var a1 = Solution[i]
		var a2 = Solution[i+1]
		var a3 = Solution[i+2]
		var a4 = Solution[i+3]
		if a1 == a2 && a1 == a3 && a1 == a4:
			 Solution[i+1] = ( Solution[i+1]+1)%Audio.size()		
	
	lightmats = [light_off,light_on,light_red,light_green]
	
	if equally_spaced:
		for n in Audio.size():
			var audio : AudioStream =Audio[n]
			if audio.get_length()>spacing:
				spacing=audio.get_length()
				
	match Audio.size():
		2:
			$boothmodel/Base/Buttons_3.queue_free()
			$boothmodel/Base/Buttons_4/Button2.visible=false
			$boothmodel/Base/Buttons_4/Button2/StaticBody/CollisionShape.disabled=true
			$boothmodel/Base/Buttons_4/Button3.visible=false
			$boothmodel/Base/Buttons_4/Button3/StaticBody/CollisionShape.disabled=true
		3:
			$boothmodel/Base/Buttons_4.queue_free()
		4:
			$boothmodel/Base/Buttons_3.queue_free()
		_:
			print(Audio.size())
			print(get_parent().name)
			print(name)
			print("ERROR WRONG NUMBER OF BUTTONS")	
	
	match Solution.size():
		4:
			lights.push_back($boothmodel/Base/Lights4/Light0)
			lights.push_back($boothmodel/Base/Lights4/Light1)
			lights.push_back($boothmodel/Base/Lights4/Light2)
			lights.push_back($boothmodel/Base/Lights4/Light3)
			$boothmodel/Base/Lights5.free()
			$boothmodel/Base/Lights6.free()
			$boothmodel/Base/Lights7.free()
		5:
			$boothmodel/Base/Lights4.free()
			lights.push_back($boothmodel/Base/Lights5/Light0)
			lights.push_back($boothmodel/Base/Lights5/Light1)
			lights.push_back($boothmodel/Base/Lights5/Light2)
			lights.push_back($boothmodel/Base/Lights5/Light3)
			lights.push_back($boothmodel/Base/Lights5/Light4)
			$boothmodel/Base/Lights6.free()
			$boothmodel/Base/Lights7.free()
		6:
			$boothmodel/Base/Lights4.free()
			$boothmodel/Base/Lights5.free()
			lights.push_back($boothmodel/Base/Lights6/Light0)
			lights.push_back($boothmodel/Base/Lights6/Light1)
			lights.push_back($boothmodel/Base/Lights6/Light2)
			lights.push_back($boothmodel/Base/Lights6/Light3)
			lights.push_back($boothmodel/Base/Lights6/Light4)
			lights.push_back($boothmodel/Base/Lights6/Light5)
			$boothmodel/Base/Lights7.free()
		7:
			$boothmodel/Base/Lights4.free()
			$boothmodel/Base/Lights5.free()
			$boothmodel/Base/Lights6.free()
			lights.push_back($boothmodel/Base/Lights7/Light0)
			lights.push_back($boothmodel/Base/Lights7/Light1)
			lights.push_back($boothmodel/Base/Lights7/Light2)
			lights.push_back($boothmodel/Base/Lights7/Light3)
			lights.push_back($boothmodel/Base/Lights7/Light4)
			lights.push_back($boothmodel/Base/Lights7/Light5)
			lights.push_back($boothmodel/Base/Lights7/Light6)
	

	
	for n in lights.size():
		set_light(n,0)
		

var playing : bool =false

func on_pressed(n_i):
	if playing:
		return
		
	timestamp = timestamp+1
		
	$AudioStreamPlayer3D.stream = Audio[n_i] 
	$AudioStreamPlayer3D.play()
	print("onpressed"+str(n_i))
	
	if solved:
		return
	
	var idx = inputarray.size()
	

	for n in Solution.size():
		if n==idx:
			set_light(n,1)
		else:
			set_light(n,0)
	
	var cheat = Input.is_key_pressed(KEY_SHIFT) && OS.is_debug_build()
	
	var sceneroot = get_tree().get_root()
	print(sceneroot)
	print(sceneroot.name)
	
	var audiostreamplayer:AudioStreamPlayer = level.find_node("AudioStreamPlayer",false)
	
	inputarray.append(n_i)
	print(str(inputarray.size())+" - "+str(Solution.size()))	
	if inputarray.size()==Solution.size():
		playing=true
		yield(get_tree().create_timer(Audio[n_i].get_length()), "timeout")
		var won=true
		for i in Solution.size():
			if inputarray[i]!=Solution[i]:
				won=false
		if cheat:
			won=true
		if won:
			solved=true
			var groupsolved = level.solvedgroup(self)
			if groupsolved:
				audiostreamplayer.stream = jingle_solve_area
				audiostreamplayer.play()		
				level.Player.doflash()
			else:
				$AudioStreamPlayer3D.stream = jingle_solve
				$AudioStreamPlayer3D.play()		
		else:			
			$AudioStreamPlayer3D.stream = jingle_lose
			$AudioStreamPlayer3D.play()			
			
		var mm=6
		if won:
			mm=7
		for m in mm:
			for n in lights.size():				
				if m%2==1:
						set_light(n,0)				 
				elif won:
						set_light(n,3)
				else:
						set_light(n,2)
			yield(get_tree().create_timer(0.3), "timeout")
		if won:
			solved=true
			level.onsolve(self)
	
		inputarray=[]
		playing=false
		
		
	pass


func set_light(n,col):
	var light : MeshInstance = lights[n] as MeshInstance
	light.material_override = lightmats[col]
	
func do_play():
	if playing:
		return
		
		
	timestamp=timestamp+1
	
	inputarray=[]
	
	for n in Solution.size():
		set_light(n,0)
		
	print("do_play")
	var basecolour = 0
	if solved:
		basecolour=3
	for n in Solution.size():
		if n>0:			
			set_light(n-1,basecolour)
		set_light(n,1)
		var sound_index : int = Solution[n]
		var sound : AudioStream = Audio[sound_index]
		$AudioStreamPlayer3D.stream = sound
		$AudioStreamPlayer3D.play()		
		var delay = sound.get_length()
		if equally_spaced:
			delay = spacing
		var curtimestamp = timestamp
		yield(get_tree().create_timer(delay), "timeout")
		if curtimestamp!=timestamp:
			return
		
		
	for n in Solution.size():
		set_light(n,basecolour)
		
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
