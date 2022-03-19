extends Spatial

export(Array, int) var Solution : Array = [ 1,0,1,1,0 ]
export(Array, AudioStream) var Audio : Array = []
export var equally_spaced:bool = true

var light_off = preload("res://models/Lampe_off.material")
var light_on = preload("res://models/Lampe_on.material")
var light_red = preload("res://models/Lampe_red.material")
var light_green = preload("res://models/Lampe_green.material")
	
var lights : Array = []

var lightmats : Array = []
	
var inputarray:Array=[]
var spacing:float=-1
# Called when the node enters the scene tree for the first time.
func _ready():
	lightmats = [light_off,light_on,light_red,light_green]
	
	if equally_spaced:
		for n in Audio.size():
			var audio : AudioStream =Audio[n]
			if audio.get_length()>spacing:
				spacing=audio.get_length()
				
	match Audio.size():
		2:
			$boothmodel/Base/Buttons_3.free()
			$boothmodel/Base/Buttons_4.visible=true
			$boothmodel/Base/Buttons_4/Button2.visible=false
			$boothmodel/Base/Buttons_4/Button2/StaticBody/CollisionShape.disabled=true
			$boothmodel/Base/Buttons_4/Button3.visible=false
			$boothmodel/Base/Buttons_4/Button3/StaticBody/CollisionShape.disabled=true
		3:
			$boothmodel/Base/Buttons_3.visible=true
			$boothmodel/Base/Buttons_4.free()
		4:
			$boothmodel/Base/Buttons_3.free()
		_:
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
		
	$AudioStreamPlayer3D.stream = Audio[n_i] 
	$AudioStreamPlayer3D.play()
	print("onpressed"+str(n_i))
	
	
	
	var idx = inputarray.size()
	

	if idx>0:			
		set_light(idx-1,0)
	set_light(idx,1)
	
	
	inputarray.append(n_i)
	print(str(inputarray.size())+" - "+str(Solution.size()))	
	if inputarray.size()==Solution.size():
		playing=true
		yield(get_tree().create_timer(Audio[n_i].get_length()), "timeout")
		var won=true
		for i in Solution.size():
			if inputarray[i]!=Solution[i]:
				won=false
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
		inputarray=[]
		playing=false
		
		
	pass


func set_light(n,col):
	var light : MeshInstance = lights[n] as MeshInstance
	light.material_override = lightmats[col]
	
func do_play():
	if playing:
		return
		
	inputarray=[]
	playing=true
	
	for n in Solution.size():
		set_light(n,0)
		
	print("do_play")
	for n in Solution.size():
		if n>0:			
			set_light(n-1,0)
		set_light(n,1)
		var sound_index : int = Solution[n]
		var sound : AudioStream = Audio[sound_index]
		$AudioStreamPlayer3D.stream = sound
		$AudioStreamPlayer3D.play()		
		var delay = sound.get_length()
		if equally_spaced:
			delay = spacing
		yield(get_tree().create_timer(delay), "timeout")
		
		
	for n in Solution.size():
		set_light(n,0)
		
	playing=false
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
