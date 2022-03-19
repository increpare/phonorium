extends Node

var mat_button_flash : Material = load("res://models/Play_Flash.material")
var mat_button : Material = load("res://models/Play.material")

var root_parent:Spatial

func _ready():
	root_parent = get_parent().get_parent().get_parent().get_parent()

var looping:bool = false

func interact():
	
	root_parent.do_play()
	
	print("interact")
	if looping:
		return
	
	looping=true
	
	var parent : MeshInstance = self.get_parent() as MeshInstance
	parent.set_surface_material(0, mat_button_flash);
	print(self.name)		
	yield(get_tree().create_timer(0.2), "timeout")
	print(parent.name)		
	parent.set_surface_material(0, mat_button);
	looping=false

