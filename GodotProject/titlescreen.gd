extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var selected:Array
	
var index:int

var has_save:bool
	
var sfx_selections = [
	preload("res://audio/select_4.wav"),
	preload("res://audio/select_3.wav"),
	preload("res://audio/select_2.wav"),
	preload("res://audio/select_1.wav"),
]
var sfx_action = [
	preload("res://audio/select_newgame.wav"),
	preload("res://audio/select_newgame.wav"),
	preload("res://audio/select_credits.wav"),
	preload("res://audio/select_quit.wav"),	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	selected = [ 
	$Camera2/Menu/option_newgame, 
	$Camera2/Menu/option_continue, 
	$Camera2/Menu/option_credits,
	$Camera2/Menu/options_quit
	]
	var save_file = File.new()
	has_save = save_file.file_exists("user://savegame.save")


	if has_save:
		index=1
	else:
		index=0
	redraw()	

func redraw():
	for i in 4:
		var node:Sprite3D = selected[i]
		var highlighted = i==index
		var enabled = true
		if has_save==false and i==1:
			enabled=false
		
		if i==3 and OS.get_name()=="HTML5":
			node.visible=false
			
		var child:Spatial = node.get_child(0)
		child.visible=highlighted
		if highlighted:
			node.scale = Vector3(0.105,0.105,1)
		else:
			node.scale = Vector3(0.096,0.096,1)
		if enabled:
			node.modulate = Color.white
			node.opacity = 1
		else:
			node.modulate = Color.black
			node.opacity = 0.9
		
		
			
func clearSaveData():
	if has_save:
		var dir = Directory.new()
		dir.remove("user://savegame.save")

var leaving:bool=false


func _process(delta):
	if leaving:
		return
		
	var y0=-0.17
	var y1=0.17
	var target_bg_y = y0
	
	var bgt:Vector3 = $Camera2/bg.translation
	bgt.y = lerp(bgt.y,target_bg_y,delta*0.3)
	$Camera2/bg.translation=bgt
		
	if Input.is_action_just_pressed("ui_up"):
		if index>0:
			index = index - 1
			if (has_save==false) and index==1:
				index=0
			$AudioStreamPlayer.stream = sfx_selections[index]
			$AudioStreamPlayer.play()
			redraw()
			
	if Input.is_action_just_pressed("ui_down"):
		if index<3:
			index = index + 1
			if (has_save==false) and index==1:
				index=2
				
				
			if index==3 and OS.get_name()=="HTML5":	
				index=2
			else:
				$AudioStreamPlayer.stream = sfx_selections[index]
				$AudioStreamPlayer.play()
			redraw()
	if Input.is_action_just_pressed("ui_accept"):
		leaving=true
		$AudioStreamPlayer.stream = sfx_action[index]
		$AudioStreamPlayer.play()
		for i in 4:
			var sel : Spatial = selected[index]
			sel.visible = i%2==0
			yield(get_tree().create_timer(0.2), "timeout")
		
		if OS.get_name()=="HTML5":
			$MusicPlayer.stop()
			
		match index:
			0:
				clearSaveData()
				get_tree().change_scene("res://Level.tscn")
			1:
				get_tree().change_scene("res://Level.tscn")
			2:
				get_tree().change_scene("res://credits.tscn")
			3:
				get_tree().quit()
		
