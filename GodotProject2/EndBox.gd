extends Area


func _ready():
	connect("body_entered",self,"on_body_enter",[],0)
	pass # Replace with function body.


func on_body_enter(body: Node) -> void:
	if body.name!="Player":
		return
	get_tree().change_scene("res://ending.tscn")
