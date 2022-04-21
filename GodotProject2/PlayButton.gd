extends Node

var mat_button_flash : Material = load("res://models/Play_Flash.material")
var mat_button : Material = load("res://models/Play.material")

var root_parent:Spatial

signal on_done

func _ready():
	root_parent = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
	connect("on_done", self, "on_done_handler")

var looping:bool = false


func on_done_handler():
	var water_spout : Spatial = get_parent().find_node("WaterSpout",false)
	water_spout.visible=false
	

func interact():
	
	root_parent.do_play(self)
	
	print("interact")
	if looping:
		return
	
	looping=true
	
	var parent : Spatial = self.get_parent().get_parent() as Spatial
	var water_level : Spatial = get_parent().get_parent().get_parent().find_node("WaterLevel",false)
	var water_spout : Spatial = get_parent().find_node("WaterSpout",false)
	var oldpos_head = parent.translation
	var oldpos_water = water_level.translation
	
	parent.translate_object_local(-Vector3.UP*0.165)
	water_level.translate_object_local(Vector3.UP*0.085)
	
	yield(get_tree().create_timer(0.2), "timeout")
	water_spout.visible=true
	parent.translation = oldpos_head
	water_level.translation = oldpos_water
	
	looping=false

